require 'spec_helper'

describe Rating do
  describe "when creating a rating for a conversation" do
    before(:each) do
      @mock_person = Factory.create(:normal_person)      
    end
    context "and the conversation id is not given" do
      it "should return a rating with an error" do
        rating = Rating.create({:person_id=>1, :rating=>1})
        rating.errors[:rateable_id].nil?.should == false
        rating.errors[:rateable_id].blank?.should == false  
      end
    end
    context "and there is a validation error with the rating" do
      it "should return a rating with an error" do
        conversation = Factory.create(:conversation)
        conversation.rate!(11,@mock_person)
        conversation.ratings.count.should == 0
      end
    end
    context "and the rating saves successfully" do
      it "should add the rating to a conversation" do
        conversation = Factory.create(:conversation)
        conversation.rate!(1, @mock_person)
        conversation.ratings.count.should == 1
      end
      it "should set the passed in user as the owner" do
        conversation = Factory.create(:conversation)
        conversation.rate!(1, @mock_person)
        conversation.ratings[0].person.should == @mock_person
      end
      it "should properly calculate total rating" do
        conversation = Factory.create(:conversation)
        conversation.rate!(1, @mock_person)
        conversation.rate!(1, @mock_person)
        conversation.total_rating.should == 2
      end
      it "should properly calculate recent rating" do
        conversation = Factory.create(:conversation)
        conversation.rate!(1, @mock_person)
        conversation.ratings[0].update_attribute(:created_at, (Time.now - 31.days))
        conversation.rate!(1, @mock_person)
        conversation.rate!(0, @mock_person)
        conversation.recent_rating.should == 1
      end
    end
  end  
end
