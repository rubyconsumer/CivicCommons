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

  context "survey_confirmation" do
    def given_sending_a_survey_confirmation
      @survey_response = Factory.create(:vote_survey_response)
      @notification = Notifier.survey_confirmation(@survey_response.person, @survey_response.survey).deliver
    end
    it "should send it correctly" do
      given_sending_a_survey_confirmation
      @notification.body.should contain 'Thank you for participating on our vote'
      @notification.body.should contain "Please check back on #{@survey_response.survey.end_date.to_s(:long)} to see the results"
    end
  end
end
