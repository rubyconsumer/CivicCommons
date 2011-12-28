module Subscribable
  def subscribe(subscriber)
    Subscription.find_or_create_by_subscribable_id_and_subscribable_type_and_person_id(self.id, self.class.to_s, subscriber.id)
  end

  def unsubscribe(subscriber)
    Subscription.where(:subscribable_id => self.id, :subscribable_type => self.class, :person_id => subscriber).delete_all
  end

  def subscribers
    Subscription.where(:subscribable_id => self.id, :subscribable_type => self.class).collect{|subscription| subscription.person}
  end

  def friendly_name
    self.class.to_s
  end
end
