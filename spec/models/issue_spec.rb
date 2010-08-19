require 'spec_helper'

describe Issue do
  describe "when adding an issue to a conversation" do
    context "and the issue saves successfully" do
      it "should add the issue to a conversation" do
        issue = Issue.create({:description=>"Testing"})
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        issue = Issue.add_to_conversation(issue, conversation)
        conversation.posts.count.should == 1
        conversation.posts[0].postable.should == issue
      end
      it "should return an issue with no errors" do
        issue = Issue.create({:description=>"Testing"})
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        issue = Issue.add_to_conversation(issue, conversation)
        issue.errors.count.should == 0
      end      
    end
  end  
end

describe Comment, "when working with ratings" do
  before(:each) do
    @person = Factory.create(:normal_person)
    @issue = Issue.create({:description=>"Testing", :total_rating=>0, :recent_rating=>0, :last_rating_date=>nil}) 
  end
  describe "when rating an issue" do
    it "adds a rating to the issue" do      
      @issue.rate(1, @person)
      
      @issue.posts[0].postable.rating.should == 1
      @issue.posts[0].postable.person.should == @person      
    end
    it "modifies the total_rating for the issue" do
      @issue.rate(1, @person)
      
      @issue.total_rating.should == 1
    end
    it "modifies the recent_rating for the issue" do
      @issue.rate(1, @person)
      
      @issue.recent_rating.should == 1
    end
    it "updates the last rated date" do
      current_time = Time.now
      Time.stub(:now).and_return(current_time)
 
      @issue.rate(1, @person)
      
      @issue.last_rating_date.should == current_time
    end    
    context "and the non-persisance rating method is called" do    
      it "should not persist the new rating" do
        @issue.rate(1, @person)
      
        new_issue = Issue.find(@issue.id)

        new_issue.total_rating.should == 0         
      end      
    end
    context "and the persist rating method is called" do
       it "should persist the new rating" do
         @issue.rate!(1, @person)
       
         new_issue = Issue.find(@issue.id)

         new_issue.total_rating.should == 1         
       end
    end
  end
  describe "when calculating the recent rating" do
    it "should sum all ratings in the last 30 days" do
      rating_one = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 60.days)})
      Post.create({:postable_id=>rating_one.id, :postable_type=>Rating.to_s, :conversable_type => Issue.to_s, :conversable_id=>@issue.id, :display_time=>(Time.now - 60.days), :created_at=>(Time.now - 60.days)})
      rating_two = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 29.days)})
      Post.create({:postable_id=>rating_two.id, :postable_type=>Rating.to_s, :conversable_type => Issue.to_s, :conversable_id=>@issue.id, :display_time=>(Time.now - 29.days), :created_at=>(Time.now - 29.days)})
      rating_three = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>Time.now})
      Post.create({:postable_id=>rating_three.id, :postable_type=>Rating.to_s, :conversable_type => Issue.to_s, :conversable_id=>@issue.id, :display_time=>Time.now, :created_at=>Time.now})
      
      @issue.calculate_recent_rating.should == 2
    end
  end
end
