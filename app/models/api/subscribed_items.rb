class Api::SubscribedItems

  def self.for_person_by_id(person_id, request)
    person = Person.find(person_id)
    if person
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
    else
      Rails.logger.warn("Person not found by PA in Api::SubscribedItems.for_person_by_id for:#{person_id}.  Called with Request:#{request}")
      nil
    end
  end

end
