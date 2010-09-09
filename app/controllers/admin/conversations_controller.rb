class Admin::ConversationsController < Admin::DashboardController
  
  #GET admin/conversations
  def index
    @conversations = Conversation.all
  end  
  
  #GET admin/conversations/new
  def new
    @conversation = Conversation.new(params[:conversation])
    @conversation.build_top_level_contribution(params[:top_level_contribution_attributes])
  end
  
  #POST admin/conversations/
  def create
    @conversation = Conversation.new(params[:conversation])
    if @conversation.save
      @conversation.top_level_contribution.datetime = Time.now
      flash[:notice] = "Thank you for creating a new conversation"
      redirect_to admin_conversations_path
    else
      redirect_to new_admin_conversation_path
    end
  end
  
  #GET admin/conversations/:id/edit
  def edit
    @conversation = Conversation.find(params[:id])
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
  end
  
end
