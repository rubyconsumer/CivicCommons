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
end
describe Conversation, "when working with ratings" do
  before(:each) do
    @person = Factory.create(:normal_person)
    @conversation = Conversation.create({:summary=>"Testing", :total_rating=>0, :recent_rating=>0, :last_rating_date=>nil}) 
  end
  describe "when rating an Question" do
     it "adds a rating to the Question" do      
       @conversation.rate(1, @person)
       
       @conversation.posts[0].postable.rating.should == 1
       @conversation.posts[0].postable.person.should == @person      
     end
     it "modifies the total_rating for the Question" do
       @conversation.rate(1, @person)
       
       @conversation.total_rating.should == 1
     end
     it "modifies the recent_rating for the Question" do
       @conversation.rate(1, @person)
       
       @conversation.recent_rating.should == 1
     end
     it "updates the last rated date" do
       current_time = Time.now
       Time.stub(:now).and_return(current_time)
  
       @conversation.rate(1, @person)
       
       @conversation.last_rating_date.should == current_time
     end
     context "and the non-persisance rating method is called" do    
       it "should not persist the new rating" do
         @conversation.rate(1, @person)

         new_event = Conversation.find(@conversation.id)

         new_event.total_rating.should == 0         
       end      
     end
     context "and the persist rating method is called" do
        it "should persist the new rating" do
          @conversation.rate!(1, @person)

          new_conversation = Conversation.find(@conversation.id)

          new_conversation.total_rating.should == 1         
        end
     end
   end
  describe "when calculating the recent rating" do
    it "should sum all ratings in the last 30 days" do
      rating_one = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 60.days)})
      Post.create({:postable_id=>rating_one.id, :postable_type=>Rating.to_s, :conversable_type => Conversation.to_s, :conversable_id=>@conversation.id, :display_time=>(Time.now - 60.days), :created_at=>(Time.now - 60.days)})
      rating_two = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 29.days)})
      Post.create({:postable_id=>rating_two.id, :postable_type=>Rating.to_s, :conversable_type => Conversation.to_s, :conversable_id=>@conversation.id, :display_time=>(Time.now - 29.days), :created_at=>(Time.now - 29.days)})
      rating_three = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>Time.now})
      Post.create({:postable_id=>rating_three.id, :postable_type=>Rating.to_s, :conversable_type => Conversation.to_s, :conversable_id=>@conversation.id, :display_time=>Time.now, :created_at=>Time.now})
      
      @conversation.calculate_recent_rating.should == 2
    end
  end
end