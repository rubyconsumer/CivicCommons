class Api::ConversationsController < ActionController::Base
  respond_to :json


  def index

    contributed_conversations =
      Api::ContributedConversations.for_person_by_email(params[:email])

    respond_with contributed_conversations
  end


end
