require 'spec_helper'

describe Comment do
  describe "when creating a comment for a conversation" do
    context "and the conversation id is not correct" do
      it "should return a comment with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        comment = Comment.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 999)
        comment.errors[:conversation_id].nil?.should == false
        comment.errors[:conversation_id].blank?.should == false  
      end
    end
    context "and there is a validation error with the comment" do
      it "should return a comment with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        comment = Comment.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>nil}, 999)
        comment.errors.count.should_not == 0
      end
    end
    context "and the comment saves successfully" do
      it "should add the comment to a conversation" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        comment = Comment.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1)
        conversation.comments.include?(comment).should == true
      end
      it "should return a comment with no errors" do
      end      
    end
  end
end
