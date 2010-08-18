require File.dirname(__FILE__) + '/../spec_helper'

describe TopItem, "when retrieving the top items by date" do
  before(:each) do
    @seven_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 7.days)})
    @three_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 3.days)})    
    @today_conversation = Factory.create(:conversation, {:created_at=>Time.now})    
    @seven_day_issue = Factory.create(:issue, {:created_at=>(Time.now - 7.days)})
    @seven_day_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_issue.id, :postable_type=>Issue.to_s, :created_at=>(Time.now-7.days)})
    @three_day_issue = Factory.create(:issue, {:created_at=>(Time.now - 3.days)})
    @three_day_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_issue.id, :postable_type=>Issue.to_s, :created_at=>(Time.now-3.days)})    
    @today_issue = Factory.create(:issue, {:created_at=>Time.now})
    @today_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_issue.id, :postable_type=>Issue.to_s, :created_at=>Time.now})    
    @seven_day_comment = Factory.create(:comment, {:created_at=>(Time.now - 7.days)})
    @seven_day_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_comment.id, :postable_type=>Comment.to_s, :created_at=>(Time.now-7.days)})
    @three_day_comment = Factory.create(:comment, {:created_at=>(Time.now - 3.days)})
    @three_day_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_comment.id, :postable_type=>Comment.to_s, :created_at=>(Time.now-3.days)})    
    @today_comment = Factory.create(:comment, {:created_at=>Time.now})
    @today_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_comment.id, :postable_type=>Comment.to_s, :created_at=>Time.now})    
    @seven_day_event = Factory.create(:event, {:created_at=>(Time.now - 7.days)})
    @seven_day_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_event.id, :postable_type=>Event.to_s, :created_at=>(Time.now-7.days)})
    @three_day_event = Factory.create(:event, {:created_at=>(Time.now - 3.days)})
    @three_day_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_event.id, :postable_type=>Event.to_s, :created_at=>(Time.now-3.days)})    
    @today_event = Factory.create(:event, {:created_at=>Time.now})
    @today_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_event.id, :postable_type=>Event.to_s, :created_at=>Time.now})    
    @three_day_question = Factory.create(:question, {:created_at=>(Time.now - 3.days)})
    @three_day_question_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_question.id, :postable_type=>Question.to_s, :created_at=>(Time.now-3.days)})    
    @today_question = Factory.create(:question, {:created_at=>Time.now})
    @today_question_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_question.id, :postable_type=>Question.to_s, :created_at=>Time.now})            
  end
  
  it "should merge postables and conversations" do
    result = TopItem.newest_items
    
    result.include?(@three_day_conversation).should == true
    result.include?(@today_conversation).should == true
    result.include?(@three_day_issue).should == true
    result.include?(@today_issue).should == true
    result.include?(@three_day_comment).should == true
    result.include?(@today_comment).should == true
    result.include?(@three_day_event).should == true
    result.include?(@today_event).should == true
    result.include?(@three_day_question).should == true
    result.include?(@today_question).should == true

    result.include?(@seven_day_conversation).should == false
    result.include?(@seven_day_issue).should == false
    result.include?(@seven_day_comment).should == false    
  end  
  
  it "should return the number passed in" do
    result = TopItem.newest_items(5)
    result.count.should == 5
  end
  
  it "should return 10 items if no limit is passed in" do
    result = TopItem.newest_items
    result.count.should == 10
  end
  
  it "should not include ratings" do
    @today_rating = Factory.create(:rating, {:created_at=>Time.now})
    @today_rating_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_rating.id, :postable_type=>Rating.to_s, :created_at=>Time.now})    

    result = TopItem.newest_items
    result.include?(@today_rating).should == false    
  end
end
