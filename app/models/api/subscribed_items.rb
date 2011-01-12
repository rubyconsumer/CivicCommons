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
    subscriptions = person.subscriptions.order('subscriptions.created_at DESC')
    subscriptions = subscriptions.where(subscribable_type: request['type']) if request['type']

    subscriptions.map do |subscription|
      subscription = SubscriptionPresenter.new(subscription, request)

      hash = {
        id: subscription.parent_id,
        title: subscription.parent_title,
        url: subscription.parent_url
      }

      hash[:type] = subscription.parent_type unless request['type']

      hash
    end
  end

end


