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

  describe "Subscription#display_name" do

    context "Subscribable type is an Issue" do
      it "returns the issue's name" do
        issue = Issue.create(name: "Cleveland Rocks")
        subscription = Subscription.create(subscribable_type: issue.class.to_s, subscribable_id: issue.id)
        subscription.display_name == "Cleveland Rocks"
      end
    end

    context "Subscribably type is a Conversation" do
      it "returns the conversation's title" do
        conversation = Conversation.create(title: "How to improve Cleveland")
        subscription = Subscription.create(subscribable_type: conversation.class.to_s, subscribable_id: conversation.id)
        subscription.display_name == "How to improve Cleveland"
      end
    end

  end

end
