class Api::ContributedConversations

  def self.for_person_by_id(person_id, request)
    person = Person.find(person_id)
    if person
      conversations = person.contributed_conversations.order('created_at DESC')

      conversations.map do |conversation|
        conversation = ConversationPresenter.new(conversation, request)
        {
          title: conversation.title,
          image: conversation.image.url(:panel),
          image_width: conversation.geometry_for_style(:panel).width.to_i,
          image_height: conversation.geometry_for_style(:panel).height.to_i,
          summary: conversation.summary,
          participant_count: conversation.participants.count,
          contribution_count: conversation.contributions.where(owner: person).count,
          url: conversation.url
        }
      end
    else
      Rails.logger.warn("Person not found by ID in Api::ContributedConversations.for_person_by_id for:#{person_id}.  Called with Request:#{request}")
      nil
    end
  end

end
