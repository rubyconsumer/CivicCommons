require 'spec_helper'

describe Question do
  describe "when creating a question for a conversation" do
    before(:each) do
      @mock_person = Factory.create(:normal_person)      
    end
    context "and the conversation id is not correct" do
      it "should return a question with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        question = Question.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 999, @mock_person)
        question.errors[:parent_id].nil?.should == false
        question.errors[:parent_id].blank?.should == false  
      end
    end
    context "and there is a validation error with the comment" do
      it "should return a comment with an error" do
        Conversation.stub(:find).with(999).and_return(nil)
        question = Question.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>nil}, 999, @mock_person)
        question.errors.count.should_not == 0
      end
    end
    context "and the comment saves successfully" do
      it "should add the comment to a conversation" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        question = Question.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person)
        conversation.posts.count.should == 1
        conversation.posts[0].postable.should == question
      end
      it "should return a comment with no errors" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        question = Question.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person)
        question.errors.count.should == 0
      end  
      it "should set the passed in user as the owner" do
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        question = Question.create_for_conversation({:datetime=>Time.now, :owner=>1, :content=>"Hello World"}, 1, @mock_person)
        question.person.should == @mock_person
      end    
    end
  end  
end
describe Question, "when working with ratings" do
  before(:each) do
    @person = Factory.create(:normal_person)
    @question = Question.create({:content=>"Testing", :total_rating=>0, :recent_rating=>0, :last_rating_date=>nil}) 
  end
  describe "when rating an Question" do
     it "adds a rating to the Question" do      
       @question.rate(1, @person)
       
       @question.posts[0].postable.rating.should == 1
       @question.posts[0].postable.person.should == @person      
     end
     it "modifies the total_rating for the Question" do
       @question.rate(1, @person)
       
       @question.total_rating.should == 1
     end
     it "modifies the recent_rating for the Question" do
       @question.rate(1, @person)
       
       @question.recent_rating.should == 1
     end
     it "updates the last rated date" do
       current_time = Time.now
       Time.stub(:now).and_return(current_time)
  
       @question.rate(1, @person)
       
       @question.last_rating_date.should == current_time
     end
     context "and the non-persisance rating method is called" do    
       it "should not persist the new rating" do
         @question.rate(1, @person)

         new_question = Question.find(@question.id)

         new_question.total_rating.should == 0         
       end      
     end
     context "and the persist rating method is called" do
        it "should persist the new rating" do
          @question.rate!(1, @person)

          new_question = Question.find(@question.id)

          new_question.total_rating.should == 1         
        end
     end     
   end
  describe "when calculating the recent rating" do
    it "should sum all ratings in the last 30 days" do
      rating_one = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 60.days)})
      Post.create({:postable_id=>rating_one.id, :postable_type=>Rating.to_s, :conversable_type => Question.to_s, :conversable_id=>@question.id, :display_time=>(Time.now - 60.days), :created_at=>(Time.now - 60.days)})
      rating_two = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>(Time.now - 29.days)})
      Post.create({:postable_id=>rating_two.id, :postable_type=>Rating.to_s, :conversable_type => Question.to_s, :conversable_id=>@question.id, :display_time=>(Time.now - 29.days), :created_at=>(Time.now - 29.days)})
      rating_three = Rating.create({:rating=>1, :person_id=>@person.id, :created_at=>Time.now})
      Post.create({:postable_id=>rating_three.id, :postable_type=>Rating.to_s, :conversable_type => Question.to_s, :conversable_id=>@question.id, :display_time=>Time.now, :created_at=>Time.now})
      
      @question.calculate_recent_rating.should == 2
    end
  end
end

