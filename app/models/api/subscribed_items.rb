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
        id: subscription.parent_id,
        title: subscription.parent_title,
        url: subscription.parent_url,
        type: subscription.parent_type
      }
    end
  end

end


