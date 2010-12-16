module Marketable
  module InstanceMethods
    def set_marketable
      if is_marketable?
        marketable = true
        marketable_at = DateTime.now
      end
    end
    
    def is_marketable?
      raise Exception, "Marketable Method Unimplemented. Marketable.subscribe_to_email_marketing?"
    end

    def subscribe!
      subscribe_to_marketing_email
    end

    def subscribe_to_marketing_email
      raise Exception, "Marketable Method Unimplemented. Marketable.subscribe_to_marketing_email"
    end
  end

  def self.included(receiver)
    receiver.class_eval do
      attr_accessor :subscribe_to_email_marketing, :skip_email_marketing

      before_save :set_marketable
      after_save :subscribe!, :if => :is_marketable?
    end

    receiver.send :include, InstanceMethods
  end
end
