class Admin::ConversationsController < ApplicationController
  
  layout 'admin'
  
  #GET admin/conversations
  def index
    @conversations = Conversation.all
  end  
  
  #GET admin/conversations/new
  def new
    @conversation = Conversation.new(params[:conversation])
  end
  
end
