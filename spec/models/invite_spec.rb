require 'spec_helper'

describe Invite do

  describe "parse email" do
    let(:valid_results) {['alpha@example.com', 'bravo@example.com', 'charlie@example.com']}

    it "should parse emails delimited by commas" do
      emails = "alpha@example.com, bravo@example.com, charlie@example.com"

      email_results = Invite.parse_emails(emails)
      email_results.should == valid_results
    end

    it "should parse emails delimited by lines" do
      emails = "alpha@example.com\r\n bravo@example.com\r\ncharlie@example.com"
      email_results = Invite.parse_emails(emails)
      email_results.should == valid_results

      emails = "alpha@example.com\nbravo@example.com\ncharlie@example.com"
      email_results = Invite.parse_emails(emails)
      email_results.should == valid_results

      emails = "alpha@example.com\rbravo@example.com\rcharlie@example.com"
      email_results = Invite.parse_emails(emails)
      email_results.should == valid_results
    end
    it "should parse emails with space in between them" do
      emails = 'alpha@example.com bravo@example.com charlie@example.com'
      Invite.parse_emails(emails).should == valid_results
    end
  end

  describe "send_invites" do
    it "should not escape the html of the summary" do
      summary = '<em>Strong Tag Here</em>'
      conversation = Factory.create(:conversation,:summary=> summary)
      user = Factory.create(:registered_user)
      Invite.send_invites('test@test.com',user,conversation)
      ActionMailer::Base.deliveries.last.body.include?(summary).should be_true
    end
    
  end
end
