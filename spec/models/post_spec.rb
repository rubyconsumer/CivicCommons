require 'spec_helper'

describe Post do
  describe "when creating a post for a conversation" do
    before(:each) do
      @mock_person = Factory.create(:normal_person)      
    end
    context "and the conversation id is not correct" do
      it "should return a entity with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        entity = Post.create_post({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 999, @mock_person, Conversation, Comment)
        entity.errors[:parent_id].nil?.should == false
        entity.errors[:parent_id].blank?.should == false  
      end
    end
    context "and there is a validation error with the entity" do
      it "should return a entity with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        entity = Post.create_post({:datetime=>Time.now, :owner=>1, :content=>nil}, 999, @mock_person, Conversation, Comment)
        entity.errors.count.should_not == 0
      end
    end
    context "and the entity saves successfully" do
      it "should add the entity to a conversation" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        entity = Post.create_post({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person, Conversation, Comment)
        conversation.posts.count.should == 1
        conversation.posts[0].postable.should == entity
      end
      it "should return a entity with no errors" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        entity = Post.create_post({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person, Conversation, Comment)
        entity.errors.count.should == 0
      end  
      it "should set the passed in user as the owner" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        entity = Post.create_post({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person, Conversation, Comment)
        entity.person.should == @mock_person
      end    
    end
  end  
end
