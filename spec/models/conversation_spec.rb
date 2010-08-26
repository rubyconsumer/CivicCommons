require 'spec_helper'

describe Conversation do
  describe "when retrieving all of the issues associated with a conversation" do
    before(:each) do
      @normal_person = Factory.create(:normal_person)      
    end
    it "should return only issue posts" do
      conversation = Factory.create(:conversation)
      issue = Factory.create(:issue)
      Issue.add_to_conversation(issue, conversation)
      Comment.create_for_conversation({:content=>"Test"}, conversation.id, @normal_person)
      conversation.save
      
      conversation.issues.count.should == 1      
      conversation.posts.count.should == 2
    end
  end
  describe "when removing all of the issues associated with a conversation" do
    it "should remove only issue posts" do
      conversation = Factory.create(:conversation)
      issue = Factory.create(:issue)
      Issue.add_to_conversation(issue, conversation)
      Comment.create_for_conversation({:content=>"Test"}, conversation.id, @normal_person)
      conversation.save
      conversation.issues = nil
      
      conversation.issues.count.should == 0      
      conversation.posts.count.should == 1
    end
  end
    
  describe "when creating a post for the conversation" do
    before(:each) do
      @comment = Factory.create(:comment)
      @person = Factory.create(:normal_person)
      @conversation = Factory.create(:conversation)
    end
    
    it "should save the comment" do      
      result = @conversation.create_post(@comment, @person)
      result.person.should == @person
    end
    
    it "should create the post" do
      result = @conversation.create_post(@comment, @person)
      @conversation.posts.count.should == 1
      @conversation.posts[0].postable.should == result      
    end
  end  
  
end