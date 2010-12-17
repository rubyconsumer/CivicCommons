require 'spec_helper'

describe Invite do
  it "is valid with a 3 digits 4 letter code" do
    Invite.new(:invitation_token => "ASD1234").should be_valid
  end
  
  it "is not valid with non-consecutive 3 digits and 4 letters code." do
    Invite.new(:invitation_token => "1SXA234").should_not be_valid
    Invite.new(:invitation_token => "A1B2C34").should_not be_valid
  end
  
  it "should not allow invite codes larger than 7 characters" do
    Invite.new(:invitation_token => "XZZZ9999X").should_not be_valid
  end
  
  it "should not allow invite codes less than 7 characters" do
    Invite.new(:invitation_token => "ZZZ888").should_not be_valid
  end
end
