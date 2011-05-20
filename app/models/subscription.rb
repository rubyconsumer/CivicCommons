class Subscription < ActiveRecord::Base
  belongs_to :subscribable, :polymorphic => true
  belongs_to :person

  delegate :title, to: :subscribable
  delegate :name,  to: :subscribable

  def self.subscribable?(subscription_type, subscription_id, subscriber)
    subscribable_model = subscription_type.camelize.constantize
    return subscribable_model.include? Subscribable
  end

  def self.subscribe(subscription_type, subscription_id, subscriber)
    if self.subscribable?(subscription_type, subscription_id, subscriber)
      subscribable_model.subscribe(subscription_id, subscriber)
    else
      raise(ArgumentError, "#{model}'s can not be subscribed to.")
    end
  end

  def self.unsubscribe(subscription_type, subscription_id, subscriber)
    if self.subscribable?(subscription_type, subscription_id, subscriber)
      subscribable_model.unsubscribe(subscription_id, subscriber)
    else
      raise(ArgumentError, "#{model}'s can not be subscribed to.")
    end
  end

  def display_name
    if self.subscribable_type == "Issue"
      name
    elsif self.subscribable_type == "Conversation"
      title
    end
  end

  def self.create_unless_exists(person, subscribable)
    unless person.subscriptions.collect{|sub| sub.subscribable}.include?(subscribable)
      person.subscriptions.create(subscribable: subscribable)
    end
  end

end
