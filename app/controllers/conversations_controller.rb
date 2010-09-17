class ConversationsController < ApplicationController
  before_filter :verify_admin, :only=>[:new, :create, :edit, :update, :destroy]
  
  # GET /conversations
  # GET /conversations.xml
  def index
    # Converting US date input to ISO because we don't trust the implicit string-to-date 
    # conversion in Ruby.
    unless params[:search].blank?
      unless params[:search][:started_at_less_than].blank?
        params[:search][:started_at_less_than] = convert_us_date_to_iso(params[:search][:started_at_less_than])
      end
      unless params[:search][:started_at_greater_than].blank?
        params[:search][:started_at_greater_than] = convert_us_date_to_iso(params[:search][:started_at_greater_than])
      end
      logger.info "Search from " + params[:search][:started_at_greater_than] unless params[:search][:started_at_greater_than].blank?
      logger.info "Search to " + params[:search][:started_at_less_than] unless params[:search][:started_at_less_than].blank?
    end
    @search = Conversation.search(params[:search])
    @conversations = @search.all   # or @search.relation to lazy load in view

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conversations }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.xml
  def show    
    @conversation = Conversation.includes({:top_level_contributions => :children}).find(params[:id])
    @conversation.visit!((current_person.nil? ? nil : current_person.id))
    @contribution = Contribution.new # for conversation comment form

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conversation }
    end
  end
  
  def node_conversation
    @contribution = Contribution.includes(:children).find(params[:id])
    @contribution.visit!((current_person.nil? ? nil : current_person.id))
    
    respond_to do |format|
      format.js { render :partial => "conversations/contribution/#{@contribution.type.downcase}"}
      format.html # show.html.erb
      format.xml  { render :xml => @conversation }
    end
  end
  
  def new_node_contribution
    @contribution = Contribution.new
    respond_to do |format|
      format.js { render(:partial => "conversations/tabbed_post_box", :locals => {:conversation_id => params[:conversation_id], :contribution_id => params[:contribution_id], :div_id => params[:div_id], :layout => false}) }
      format.html { render(:partial => "conversations/tabbed_post_box", :locals => {:conversation_id => params[:conversation_id], :contribution_id => params[:contribution_id], :div_id => params[:div_id], :layout => 'application'}) }
    end
  end
  
  def create_node_contribution
    parent_contribution = Contribution.find(params[:contribution][:conversation_id])
    model = params[:contribution][:type].constantize
    @contribution = model.create(:parent => parent_contribution, :content => params[:contribution][:content], :person => current_person)
    
    respond_to do |format|
      if @contribution.save
        format.js   { render :partial => "conversations/contributions/#{@contribution.type.downcase}", :locals => {:contribution => @contribution} }
        format.html { redirect_to(@contribution, :notice => 'Contribution was successfully created.') }
        format.xml  { render :xml => @contribution, :status => :created, :location => @contribution }
      else
        format.js   { render :json => @contribution.errors, :status => :unprocessable_entity }
        format.html { render :action => "new_node_contribution" }
        format.xml  { render :xml => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /conversations/new
  # GET /conversations/new.xml
  def new
    @conversation = Conversation.new
    @presenter = IngestPresenter.new(@conversation)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conversation }
    end
  end

  # GET /conversations/1/edit
  def edit
    @conversation = Conversation.find(params[:id])
  end

  # POST /conversations
  # POST /conversations.xml
  def create
    ActiveRecord::Base.transaction do 
      @conversation = Conversation.new(params[:conversation])
      #TODO: Fix this conversation issues creation since old conversation.issues= method has been destroyed
      #NOTE: Issues were previously defined as Conversation has_many Issues, but this is wrong, should be habtm
      @conversation.issues = Issue.find(params[:issue_ids]) unless params[:issue_ids].blank?
      @conversation.started_at = Time.now
      @presenter = IngestPresenter.new(@conversation, params[:file])

      @conversation.save!
      @presenter.save!
      respond_to do |format|
        format.html { redirect_to(@conversation, :notice => 'Conversation was successfully created.') }
        format.xml  { render :xml => @conversation, :status => :created, :location => @conversation }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @conversation.errors + @presenter.errors, :status => :unprocessable_entity }
    end
  end
  # PUT /conversations/1
  # PUT /conversations/1.xml
  def update
    @conversation = Conversation.find(params[:id])

    respond_to do |format|
      if @conversation.update_attributes(params[:conversation])
        format.html { redirect_to(@conversation, :notice => 'Conversation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /conversations/rate
  # POST /conversations/rate.xml
  def rate
    return if current_person.nil?
    
    @conversation = Conversation.find(params[:conversation_id])
    unless @conversation.nil?
      @conversation.rate!(params[:rating].to_i, current_person) unless params[:rating].nil?
      render :text=>@conversation.total_rating
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.xml
  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to(conversations_url) }
      format.xml  { head :ok }
    end
  end


  # Kludge to convert US date-time (mm/dd/yyyy hh:mm am) to an
  # ISO-like date-time (yyyy-mm-ddThh:mm:ss).
  # There is probably a better way to do this. Please refactor.
  private
  def convert_us_date_to_iso(input)
    hour = input[11,2].to_i
    if (hour == 12)
      hour = 0
    end
    if (input[17,2] == "pm")
      hour += 12
    end
    hour = sprintf("%02d",hour)
    input[6,4]+"-"+input[0,2]+"-"+input[3,2]+"T"+hour+":"+input[14,2]+":00"
  end

end
