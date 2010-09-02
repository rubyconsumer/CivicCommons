require 'spec_helper'

describe Conversation do
  describe "when retrieving all of the issues associated with a conversation" do
    before(:each) do
      @normal_person = Factory.create(:normal_person)      
    end
    it "should return issue" do
      conversation = Factory.create(:conversation)
      issue = Factory.create(:issue, :conversations=>[conversation])
      
      conversation.issues.count.should == 1      
      conversation.issues[0].should == issue
    end
  end

  describe "when creating a post for the conversation" do
    before(:each) do
      @comment = Factory.create(:comment)
      @person = Factory.create(:normal_person)
      @conversation = Factory.create(:conversation)
    end

  end  
  
end