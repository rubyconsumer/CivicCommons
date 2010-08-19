require 'spec_helper'

describe Event do
  describe "when saving an event" do
    it "should require a name" do
      event = Event.new({:title=>"", :when=>nil, :where=>"Test Location"})
      event.save.should == false
      event.errors.count.should == 1
      event.errors[:title].should_not be_empty            
    end
    
    it "should require a location" do
      event = Event.new({:title=>"Test Event", :when=>nil, :where=>""})
      event.save.should == false
      event.errors.count.should == 1
      event.errors[:where].should_not be_empty            
    end    
  end    
end
describe Event, "when working with ratings" do
  before(:each) do
    @person = Factory.create(:normal_person)
    @event = Event.create({:title=>"Testing", :where=>"Testing", :total_rating=>0, :recent_rating=>0, :last_rating_date=>nil}) 
  end
  describe "when rating an Question" do
     it "adds a rating to the Question" do      
       @event.rate(1, @person)
       
       @event.posts[0].postable.rating.should == 1
       @event.posts[0].postable.person.should == @person      
     end
     it "modifies the total_rating for the Question" do
       @event.rate(1, @person)
       
       @event.total_rating.should == 1
     end
     it "modifies the recent_rating for the Question" do
       @event.rate(1, @person)
       
       @event.recent_rating.should == 1
     end
     it "updates the last rated date" do
       current_time = Time.now
       Time.stub(:now).and_return(current_time)
  
       @event.rate(1, @person)
       
       @event.last_rating_date.should == current_time
     end
     context "and the non-persisance rating method is called" do    
       it "should not persist the new rating" do
         @event.rate(1, @person)

         new_event = Event.find(@event.id)

         new_event.total_rating.should == 0         
       end      
     end
     context "and the persist rating method is called" do
        it "should persist the new rating" do
          @event.rate!(1, @person)

          new_event = Event.find(@event.id)

          new_event.total_rating.should == 1         
        end
     end
   end
  describe "when calculating the recent rating" do
    it "should sum all ratings in the last 30 days" do
      rating_one = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 60.days)})
      Post.create({:postable_id=>rating_one.id, :postable_type=>Rating.to_s, :conversable_type => Event.to_s, :conversable_id=>@event.id, :display_time=>(Time.now - 60.days), :created_at=>(Time.now - 60.days)})
      rating_two = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 29.days)})
      Post.create({:postable_id=>rating_two.id, :postable_type=>Rating.to_s, :conversable_type => Event.to_s, :conversable_id=>@event.id, :display_time=>(Time.now - 29.days), :created_at=>(Time.now - 29.days)})
      rating_three = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>Time.now})
      Post.create({:postable_id=>rating_three.id, :postable_type=>Rating.to_s, :conversable_type => Event.to_s, :conversable_id=>@event.id, :display_time=>Time.now, :created_at=>Time.now})
      
      @event.calculate_recent_rating.should == 2
    end
  end
end

