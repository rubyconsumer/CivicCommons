require 'spec_helper'

describe Invite do
  it "is valid with a 3 digits 4 letter code" do
    Invite.new(:invitation_token => "ASD1234").should be_valid
    Invite.new(:invitation_token => "1SD1234").should_not be_valid
  end
end
