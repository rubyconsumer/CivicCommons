require 'spec_helper'

describe Notification do
  def given_a_contribution_with_conversation
    @contribution = FactoryGirl.create(:contribution)
  end
  
  describe "update_or_create_notification" do
    it "should save a notification if it exists" do
      given_a_contribution_with_conversation
      Notification.update_or_create_notification(@contribution, 123)
      Notification.count.should == 1
      Notification.update_or_create_notification(@contribution, 123)
      Notification.count.should == 1
    end
    it "should create a notification if it doesn't exist" do
      given_a_contribution_with_conversation
      Notification.count.should == 0
      Notification.update_or_create_notification(@contribution, 123)
      Notification.count.should == 1
    end
  end
  
  describe "destroy_notification" do
    it "should destroy the notification" do
      given_a_contribution_with_conversation
      Notification.update_or_create_notification(@contribution, 123)
      Notification.update_or_create_notification(@contribution, 999)
      Notification.count.should == 2
      Notification.destroy_notification(@contribution, 123)
      Notification.count.should == 1
    end
  end
  
  describe "with Contribution" do
    describe "contributed_on_created_conversation_notification" do
      it "should create notification to the contribution's conversation's owner" do
        given_a_contribution_with_conversation
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.last.receiver_id.should == @contribution.conversation.owner
      end
      it "should not create a notification if conversation doesn't exist" do
        given_a_contribution_with_conversation
        @contribution.conversation = nil
        @contribution.save
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 0
      end
    end

    describe "destroy_contributed_on_created_conversation_notification" do
      it "should destroy the Notification record" do
        given_a_contribution_with_conversation
        Notification.contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 1
        Notification.destroy_contributed_on_created_conversation_notification(@contribution)
        Notification.count.should == 0
      end
    end
  end
  
  describe "create_for" do
    context "on Contribution" do
      it "should call the contributed_on_created_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:contributed_on_created_conversation_notification)
        Notification.create_for(@contribution)
      end
    end
  end
  
  describe "destroy_for" do
    context "on Contribution" do
      it "should call the contributed_on_created_conversation_notification method" do
        given_a_contribution_with_conversation
        Notification.should_receive(:destroy_contributed_on_created_conversation_notification)
        Notification.destroy_for(@contribution)
      end
    end
  end
  
end
