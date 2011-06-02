require "spec_helper"

describe Notifier do
  context "email_changed" do
    def given_sending_a_changed_email_notification
      @notification = Notifier.email_changed('old-email@example.com','new-email@example.com').deliver
    end
    
    it "should send to the old email" do
      given_sending_a_changed_email_notification
      @notification.to.should contain 'old-email@example.com'
    end
    
    it "should have the correct subject subject" do
      given_sending_a_changed_email_notification
      @notification.subject.should contain "You've recently changed your email with The Civic Commons"
    end
    
  end
end
