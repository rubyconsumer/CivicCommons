class Api::ContributedConversations

  def self.for_person_by_people_aggregator_id(people_aggregator_id, request)
    person = Person.find_by_people_aggregator_id(people_aggregator_id)
    
    if person
      for_person(person, request)
    else
      Rails.logger.warn("Person not found by PA ID in Api::ContributedConversations.for_person_by_people_aggregator_id for:#{people_aggregator_id}.  Called with Request:#{request}")
      nil
    end
  end


  def self.for_person(person, request)
    conversations = person.contributed_conversations

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
  end

end
