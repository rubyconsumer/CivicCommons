class ContributionsController < ApplicationController
  # GET /contributions
  # GET /contributions.xml
  def index
    @contributions = Contribution.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contributions }
    end
  end

  # GET /contributions/1
  # GET /contributions/1.xml
  def show
    @contribution = Contribution.find(params[:id])
    @contribution.visit!((current_person.nil? ? nil : current_person.id))

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contribution }
    end
  end

  # GET /contributions/new
  # GET /contributions/new.xml
  def new
    @contribution = Contribution.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contribution }
    end
  end

  # GET /contributions/1/edit
  def edit
    @contribution = Contribution.find(params[:id])
  end


  def create_from_pa
    if params.has_key?(:issue_id)
      item = Issue.find(params[:issue_id])
    else
      item = Conversation.find(params[:conversation_id])
      parent = item.contributions.find(params[:parent_contribution_id])
    end
    contribution = Contribution.
      create_node_level_contribution({:type => "PAContribution",
                                       :url => params[:link],
                                       :title => params[:title],
                                       :item => item,
                                       :parent => parent},
                                     Person.find(params[:person_id]))
    contribution.save!
    redirect_to polymorphic_url(item)
                                                
  end

  # POST /contributions
  # POST /contributions.xml
  def create
    @contribution = Contribution.new(params[:contribution])

    respond_to do |format|
      if @contribution.save
        format.html { redirect_to(@contribution, :notice => 'Contribution was successfully created.') }
        format.xml  { render :xml => @contribution, :status => :created, :location => @contribution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contributions/1
  # PUT /contributions/1.xml
  def update
    @contribution = Contribution.find(params[:id])
  
    respond_to do |format|
      if @contribution.update_attributes(params[:contribution])
        format.html { redirect_to(@contribution, :notice => 'Contribution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contribution.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /contributions/1
  # DELETE /contributions/1.xml
  def destroy
    @contribution = Contribution.find(params[:id])
    @contribution.destroy
  
    respond_to do |format|
      format.html { redirect_to(contributions_url) }
      format.xml  { head :ok }
    end
  end
  
end
