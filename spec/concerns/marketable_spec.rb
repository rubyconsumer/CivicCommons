require 'spec_helper'

describe Marketable do
  before :each do
    @person = Factory.create(:marketable_person)
  end
  
  it "should be subscribable to email marketing" do
    @person.stub!(:subscribe_to_marketing_email).and_return(true)
    @person.subscribe_to_email_marketing?.should be_true
  end
end
