module Subscribable
  
  module ClassMethods
    def subscribe(identifier, subscriber)
      subscribable = self.new()
      subscribable.id = identifier
      Subscription.find_or_create_by_subscribable_id_and_subscribable_type_and_person_id(subscribable.id, subscribable.class, subscriber.id)
    end

    def unsubscribe(identifier, subscriber)
      subscribable = self.new()
      subscribable.id = identifier
      Subscription.where(:subscribable_id => subscribable.id, :subscribable_type => subscribable.class, :person_id => subscriber.id).delete_all
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  
  def subscribe(subscriber)
    Subscription.find_or_create_by_subscribable_id_and_subscribable_type_and_person_id(self.id, self.class, subscriber.id)
  end

  def unsubscribe(subscriber)
    Subscription.where(:subscribable_id => self.id, :subscribable_type => self.class, :person_id => subscriber).delete_all
  end
end
