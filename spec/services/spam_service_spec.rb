require 'spec_helper'

describe SpamService do

  context "spam?" do
    it "should reject spam emails" do
      SpamService.spam?('spammer@yeah.net').should == true
      SpamService.spam?('spammer@163.com').should == true
      SpamService.spam?('spammer@21cn.com').should == true
    end
    it "should reject spam emails with case insesitivity" do
      SpamService.spam?('imspammer@YeAh.net').should == true
    end
    it "should allow non-spam emails" do
      SpamService.spam?('jon@nospam.com').should == false
    end
  end
end
