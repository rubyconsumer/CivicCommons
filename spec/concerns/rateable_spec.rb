require 'spec_helper'

[Event, Comment, Issue, Conversation].each do |model_type|
  describe model_type.to_s, "When working with ratings" do
    before(:each) do
      @person = Factory.create(:normal_person)
      @item = Factory.create(model_type.to_s.downcase, {:total_rating=>0, :recent_rating=>0, :last_rating_date=>nil})
    end
    context "and rating a #{model_type.to_s}" do
       it "adds a rating to the #{model_type.to_s}" do      
         @item.rate(1, @person)
       
         @item.ratings[0].rating.should == 1
         @item.ratings[0].person.should == @person      
       end
       it "modifies the total_rating for the #{model_type.to_s}" do
         @item.rate(1, @person)
       
         @item.total_rating.should == 1
       end
       it "modifies the recent_rating for the #{model_type.to_s}" do
         @item.rate(1, @person)
       
         @item.recent_rating.should == 1
       end
       it "updates the last rated date" do
         current_time = Time.now
         Time.stub(:now).and_return(current_time)
  
         @item.rate(1, @person)
       
         @item.last_rating_date.should == current_time
       end
       context "and the non-persisance rating method is called" do    
         it "should not persist the new rating" do
           @item.rate(1, @person)

           new_item = model_type.find(@item.id)

           new_item.total_rating.should == 0         
         end      
       end
       context "and the persist rating method is called" do
          it "should persist the new rating" do
            @item.rate!(1, @person)

            new_item = model_type.find(@item.id)

            new_item.total_rating.should == 1         
          end
       end
    end
    context "and calculating the recent rating" do
      it "should sum all ratings in the last 30 days" do
        rating_one = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 60.days)})
        @item.ratings << rating_one
        rating_two = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 29.days)})
        @item.ratings << rating_two
        rating_three = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>Time.now})
        @item.ratings << rating_three
      
        @item.calculate_recent_rating.should == 2
      end
    end
    context "and identifying the top rated items" do  
      it "should order by recent_rating" do
        @item_10 = Factory.create(model_type.to_s.downcase, {:total_rating=>10, :recent_rating=>10, :last_rating_date=>Time.now})
        @item_5 = Factory.create(model_type.to_s.downcase, {:total_rating=>5, :recent_rating=>5, :last_rating_date=>Time.now})      
        @item_1 = Factory.create(model_type.to_s.downcase, {:total_rating=>1, :recent_rating=>1, :last_rating_date=>Time.now})            

        result = model_type.get_top_rated
    
        result[0].should == @item_10
        result[1].should == @item_5
        result[2].should == @item_1
      end
      it "should not include records if last rating is older than 30 days" do
        @item_old = Factory.create(model_type.to_s.downcase, {:total_rating=>10, :recent_rating=>10, :last_rating_date=>(Time.now - 60.days)})

        result = model_type.get_top_rated

        result.include?(@item_old).should == false
      end      
    end
  end
end
