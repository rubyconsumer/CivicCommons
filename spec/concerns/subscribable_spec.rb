require 'spec_helper'

[Conversation, Issue, Organization].each do |model_type|
  describe model_type.to_s do
    let(:item) {Factory.create(model_type.to_s.downcase)}

    before(:each) do
      @person = Factory.create(:normal_person)
    end

    context "is subscribed to a by the current user" do
      it "adds a subscription to the #{model_type.to_s} for the current user" do
        subscription = item.subscribe(@person)

        subscription.class.should == Subscription
        subscription.person.should == @person
        subscription.subscribable_type == model_type.to_s
      end
    end

    context 'is unsubscribed to by the current user' do
      it "should remove a subscription to the #{model_type.to_s} for the current user" do
        subscription = item.subscribe(@person)
        item.unsubscribe(@person)

        item.subscriptions.blank?.should be_true
      end
    end
  end
end
