class Subscription < ActiveRecord::Base
  belongs_to :subscribable, :polymorphic => true
  belongs_to :person
  
  def self.subscribe(subscription_type, subscription_id, subscriber)
    subsribable_model = subscription_type.camelize.constantize
    if subsribable_model.include? Subscribable
      subsribable_model.subscribe(subscription_id, subscriber)
    else
      raise(ArgumentError, "#{model}'s can not be subscribed to.")
    end
  end
  
  def self.unsubscribe(subscription_type, subscription_id, subscriber)
    subscribable_model = subscription_type.camelize.constantize
    if subscribable_model.include? Subscribable
      subscribable_model.unsubscribe(subscription_id, subscriber)
    else
      raise(ArgumentError, "#{model}'s can not be subscribed to.")
    end
  end
end