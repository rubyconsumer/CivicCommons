class Admin::ConversationsController < ApplicationController
  
  layout 'admin'
  
  #GET admin/conversations
  def index
    @conversations = Conversation.all
  end  
  
end
