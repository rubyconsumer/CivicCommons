require 'spec_helper'

describe DailyDigest do

  before(:each) do
    Factory.create(:normal_person, daily_digest: true, name: "John Doe")
    Factory.create(:normal_person, daily_digest: false, name: "Jane Doe")
    @digest = DailyDigest.new
  end

  describe "On creation" do

    it "prepares a list of all people that have not opted-out of the digest" do
      @digest.mailing_list.length.should == 1
      @digest.mailing_list.first.name.should == "John Doe"
    end

  end

  describe "DailyDigest#send_notice" do

    it "Sends a notice to individuals who have updated conversations" do
    end

  end



end
