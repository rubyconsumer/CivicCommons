class Admin::ConversationsController < Admin::DashboardController

  #GET admin/conversations
  def index
    @conversations = Conversation.all
  end

  #GET admin/conversations/new
  def new
    @conversation = Conversation.new(params[:conversation])
    @presenter = IngestPresenter.new(@conversation)
  end

  #POST admin/conversations/
  def create
    ActiveRecord::Base.transaction do
      @conversation = Conversation.new(params[:conversation])
      @presenter = IngestPresenter.new(@conversation, params[:transcript_file])

      @conversation.save!
      @presenter.save!
      respond_to do |format|
        format.html { redirect_to(admin_conversation_path(@conversation), :notice => 'Your conversation has been created!') }
        format.xml  { render :xml => @conversation, :status => :created, :location => @conversation }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { render new_admin_conversation_path }
      format.xml  { render :xml => @conversation.errors + @presenter.errors, :status => :unprocessable_entity }
    end
  end


  #GET admin/conversations/:id/edit
  def edit
    @conversation = Conversation.includes(:top_level_contributions).find(params[:id])
    @presenter = IngestPresenter.new(@conversation)
  end

  #PUT admin/conversations/:id
  def update
    @conversation = Conversation.find(params[:id])
    if @conversation.update_attributes(params[:conversation])
      flash[:notice] = "Successfully updated conversation"
      redirect_to admin_conversations_path
    else
      render edit_admin_conversation_path(@conversation)
    end
  end

  #GET admin/conversations/:id
  def show
    @conversation =  Conversation.find(params[:id])
  end 

  #DELETE admin/conversations/:id
  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy
    redirect_to admin_conversations_path
  end

  #POST admin/conversations/:id/toggle_staff_pick
  def toggle_staff_pick
    @conversation = Conversation.find(params[:id])
    @conversation.staff_pick = !@conversation.staff_pick

    if @conversation.save
      status = @conversation.staff_pick? ? 'on' : 'off'
      flash[:notice] = "Staff Pick is turned #{status} for \"#{@conversation.title}\""
    else
      flash[:error] = "Error saving conversation: \"#{@conversation.title}\""
    end

    if params[:redirect_to]
      redirect_to :action => params[:redirect_to]
    else
      redirect_to admin_conversation_path
    end
  end

end
