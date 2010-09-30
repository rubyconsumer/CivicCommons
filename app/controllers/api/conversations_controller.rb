class Api::ConversationsController < ActionController::Base


  def index
    person = Person.find_by_email(params[:email])
    conversations = person.contributed_conversations

    contributed_conversations =
      conversations.map do |conversation|
        {
          title: conversation.title,
          image: conversation.image.url,
          summary: conversation.summary,
          participant_count: conversation.participants.count,
          contribution_count: conversation.contributions.where(owner: person).count
        }
      end

    render :json => contributed_conversations
  end


end
