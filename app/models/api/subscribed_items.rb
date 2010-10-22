class Api::SubscribedItems

  def self.for_person_by_people_aggregator_id(people_aggregator_id, request)
    person = Person.find_by_people_aggregator_id(people_aggregator_id)
    
    if person
      for_person(person, request)
    else
      Rails.logger.warn("Person not found by PA ID in Api::SubscribedItems.for_person_by_people_aggregator_id for:#{people_aggregator_id}.  Called with Request:#{request}")
      nil
    end
  end


  def self.for_person(person, request)
    subscriptions = person.subscriptions

    subscriptions.map do |subscription|
      subscription = SubscriptionPresenter.new(subscription, request)
      {
        parent_title: subscription.parent_title,
        parent_image: subscription.parent_image.url(:panel),
        parent_image_width: subscription.parent.geometry_for_style(:panel).width.to_i,
        parent_image_height: subscription.parent.geometry_for_style(:panel).height.to_i,
        participant_count: subscription.parent.participants.count,
        contribution_count: subscription.parent.contributions.where(owner: person).count,
        parent_url: subscription.parent_url
      }
    end
  end

end


