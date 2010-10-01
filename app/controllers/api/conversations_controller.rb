class Api::ConversationsController < ActionController::Base


  def index
    person = Person.find_by_email(params[:email])

    contributed_conversations =
      Api::ContributedConversations.for_person(person)

    render :json => contributed_conversations
  end


end
