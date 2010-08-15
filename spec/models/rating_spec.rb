require 'spec_helper'

describe Rating do
  describe "when creating a rating for a conversation" do
    before(:each) do
      @mock_person = Factory.create(:normal_person)      
    end
    context "and the conversation id is not correct" do
      it "should return a rating with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        rating = Rating.create_for_conversation({:datetime=>Time.now, :person_id=>1, :rating=>1}, 999, @mock_person)
        rating.errors[:parent_id].nil?.should == false
        rating.errors[:parent_id].blank?.should == false  
      end
    end
    context "and there is a validation error with the rating" do
      it "should return a rating with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        rating = Rating.create_for_conversation({:datetime=>Time.now, :person_id=>1, :rating=>11}, 999, @mock_person)
        rating.errors.count.should_not == 0
      end
    end
    context "and the rating saves successfully" do
      it "should add the rating to a conversation" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        rating = Rating.create_for_conversation({:datetime=>Time.now, :person_id=>1, :rating=>1}, 1, @mock_person)
        conversation.posts.count.should == 1
        conversation.posts[0].postable.should == rating
      end
      it "should return a rating with no errors" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        rating = Rating.create_for_conversation({:datetime=>Time.now, :person_id=>1, :rating=>1}, 1, @mock_person)
        rating.errors.count.should == 0
      end  
      it "should set the passed in user as the owner" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        rating = Rating.create_for_conversation({:datetime=>Time.now, :person_id=>1, :rating=>1}, 1, @mock_person)
        rating.person.should == @mock_person
      end    
    end
  end  
end
