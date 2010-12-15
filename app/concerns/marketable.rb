module Marketable
  module InstanceMethods
    def newly_confirmed?
      confirmed_at_changed? && confirmed_at_was.blank? && !confirmed_at.blank?
    end
    
    def check_if_email_marketable
      @subscribe_to_email_marketing = true if newly_confirmed? && marketable.blank?
      @subscribe_to_email_marketing = false if skip_email_marketing
      Rails.logger.info "~~~set subscribe_to_email_marketing:#{@subscribe_to_email_marketing}"
    end

    def subscribe_to_email_marketing?
      Rails.logger.info "~~~subscribe_to_email_marketing?:#{@subscribe_to_email_marketing}"
      @subscribe_to_email_marketing
    end

    def subscribe_to_email_list
      # Call to Mailchimp API.  Requires: Email address, First and List Name
      Rails.logger.info "~~~ Subscribing account to mailing list: #{email}, #{first_name} #{last_name}"
      subscribed = subscribe_to_marketing_email
      Rails.logger.info "~~~ subscribed is:#{subscribed}"
      if subscribed
        Rails.logger.info "~~~ Setting up marketing info."
        marketable = true
        marketable_at = DateTime.now
        self.save!
      end
      Rails.logger.info "~~~ Subscription complete. #{email}"
    end
    
    def subscribe_to_marketing_email
      raise Exception, "Marketable Method Unimplemented. Marketable.subscribe_to_marketing_email"
    end
  end

  def self.included(receiver)
    receiver.class_eval do
      attr_accessor :subscribe_to_email_marketing, :skip_email_marketing
      
      before_save :check_if_email_marketable
      after_save :subscribe_to_email_list, :if => :subscribe_to_email_marketing?
    end
    
    # receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
