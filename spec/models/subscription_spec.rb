require 'spec_helper'

describe Subscription do
  before(:each) do
    @normal_person = Factory.create(:normal_person)
  end
  
  it "should have a person and conversation" do
    subscription = Factory.build(:conversation_subscription)
    subscription.person.name.should == "Marc Canter"
    subscription.subscribable.title.should == 'Civic Commons'
  end
  
  it "should have a person and issue" do
    subscription = Factory.build(:issue_subscription)
    subscription.person.name.should == "Marc Canter"
    subscription.subscribable.summary.should == 'Civic Commons'
  end
  
end
