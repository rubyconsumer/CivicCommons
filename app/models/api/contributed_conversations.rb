class Api::ContributedConversations

  def self.for_person_by_email(email, request)
    person = Person.find_by_email(email)
    for_person(person, request)
  end


  def self.for_person(person, request)
    conversations = person.contributed_conversations

    conversations.map do |conversation|
      conversation = ConversationPresenter.new(conversation, request)
      {
        title: conversation.title,
        image: conversation.image.url(:thumb),
        image_width: conversation.geometry_for_style(:thumb).width.to_i,
        image_height: conversation.geometry_for_style(:thumb).height.to_i,
        summary: conversation.summary,
        participant_count: conversation.participants.count,
        contribution_count: conversation.contributions.where(owner: person).count,
        url: conversation.url
      }
    end
  end

end
