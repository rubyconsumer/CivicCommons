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

end
