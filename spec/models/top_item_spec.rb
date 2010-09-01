require File.dirname(__FILE__) + '/../spec_helper'

describe TopItem, "when retrieving the top items by date" do
  before(:each) do
    @seven_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 7.days)})
    @three_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 3.days)})    
    @today_conversation = Factory.create(:conversation, {:created_at=>Time.now})    
    @seven_day_issue = Factory.create(:issue, {:conversations=>[@seven_day_conversation], :created_at=>(Time.now - 7.days)})
    #@seven_day_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_issue.id, :postable_type=>Issue.to_s, :created_at=>(Time.now-7.days)})
    @three_day_issue = Factory.create(:issue, {:conversations=>[@three_day_conversation], :created_at=>(Time.now - 3.days)})
    #@three_day_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_issue.id, :postable_type=>Issue.to_s, :created_at=>(Time.now-3.days)})    
    @today_issue = Factory.create(:issue, {:conversations=>[@today_conversation], :created_at=>Time.now})
    #@today_issue_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_issue.id, :postable_type=>Issue.to_s, :created_at=>Time.now})    
    @seven_day_comment = Factory.create(:comment, {:conversation=>@seven_day_conversation, :created_at=>(Time.now - 7.days)})
    #@seven_day_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_comment.id, :postable_type=>Comment.to_s, :created_at=>(Time.now-7.days)})
    @three_day_comment = Factory.create(:comment, {:conversation=>@three_day_conversation, :created_at=>(Time.now - 3.days)})
    #@three_day_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_comment.id, :postable_type=>Comment.to_s, :created_at=>(Time.now-3.days)})    
    @today_comment = Factory.create(:comment, {:conversation=>@today_conversation, :created_at=>Time.now})
    #@today_comment_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_comment.id, :postable_type=>Comment.to_s, :created_at=>Time.now})    
    @seven_day_event = Factory.create(:event, {:conversations=>[@seven_day_conversation], :created_at=>(Time.now - 7.days)})
    #@seven_day_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@seven_day_event.id, :postable_type=>Event.to_s, :created_at=>(Time.now-7.days)})
    @three_day_event = Factory.create(:event, {:conversations=>[@three_day_conversation], :created_at=>(Time.now - 3.days)})
    #@three_day_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_event.id, :postable_type=>Event.to_s, :created_at=>(Time.now-3.days)})    
    @today_event = Factory.create(:event, {:conversations=>[@today_conversation], :created_at=>Time.now})
    #@today_event_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_event.id, :postable_type=>Event.to_s, :created_at=>Time.now})    
    @seven_day_question = Factory.create(:question, {:conversation=>@seven_day_conversation, :created_at=>(Time.now - 7.days)})
    @three_day_question = Factory.create(:question, {:conversation=>@three_day_conversation, :created_at=>(Time.now - 3.days)})
    #@three_day_question_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@three_day_question.id, :postable_type=>Question.to_s, :created_at=>(Time.now-3.days)})    
    @today_question = Factory.create(:question, {:conversation=>@today_conversation, :created_at=>Time.now})
    #@today_question_post = Post.create({:conversable_id=>@three_day_conversation.id, :conversable_type=>Conversation.to_s, :postable_id=>@today_question.id, :postable_type=>Question.to_s, :created_at=>Time.now})            
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

describe TopItem, "when retrieving the top items by rating" do
  before(:each) do
    @ten_rating_conversation = Factory.create(:conversation, {:recent_rating=>10})
    @five_rating_conversation = Factory.create(:conversation, {:recent_rating=>5})    
    @one_rating_conversation = Factory.create(:conversation, {:recent_rating=>1})    
    Conversation.stub(:get_top_rated).and_return([@ten_rating_conversation, @five_rating_conversation, @one_rating_conversation])
    
    @ten_rating_comment = Factory.create(:comment, {:recent_rating=>10})
    @five_rating_comment = Factory.create(:comment, {:recent_rating=>5})    
    @one_rating_comment = Factory.create(:comment, {:recent_rating=>1})
    Comment.stub(:get_top_rated).and_return([@ten_rating_comment, @five_rating_comment, @one_rating_comment])
    
    @ten_rating_issue = Factory.create(:issue, {:recent_rating=>10})
    @five_rating_issue = Factory.create(:issue, {:recent_rating=>5})    
    @one_rating_issue = Factory.create(:issue, {:recent_rating=>1})
    Issue.stub(:get_top_rated).and_return([@ten_rating_issue, @five_rating_issue, @one_rating_issue])
    
    @ten_rating_question = Factory.create(:question, {:recent_rating=>10})
    @five_rating_question = Factory.create(:question, {:recent_rating=>5})    
    @one_rating_question = Factory.create(:question, {:recent_rating=>1})
    Question.stub(:get_top_rated).and_return([@ten_rating_question, @five_rating_question, @one_rating_question])
    
    @ten_rating_event = Factory.create(:event, {:recent_rating=>10})
    @five_rating_event = Factory.create(:event, {:recent_rating=>5})    
    @one_rating_event = Factory.create(:event, {:recent_rating=>1})
    Event.stub(:get_top_rated).and_return([@ten_rating_event, @five_rating_event, @one_rating_event])
  end
  
  it "should merge all rateable types" do
    result = TopItem.highest_rated
    result.include?(@ten_rating_conversation).should == true
    result.include?(@ten_rating_comment).should == true
    result.include?(@ten_rating_issue).should == true
    result.include?(@ten_rating_question).should == true
    result.include?(@ten_rating_event).should == true        
  end  
  
  it "should return the number passed in" do
    result = TopItem.highest_rated(5)
    result.count.should == 5
  end
  
  it "should return 10 items if no limit is passed in" do
    result = TopItem.highest_rated
    result.count.should == 10
  end
end

describe TopItem, "when retrieving the top items by number of visits" do
  before(:each) do
    @ten_visit_conversation = Factory.create(:conversation, {:recent_visits=>10})
    @five_visit_conversation = Factory.create(:conversation, {:recent_visits=>5})    
    @one_visit_conversation = Factory.create(:conversation, {:recent_visits=>1})    
    Conversation.stub(:get_top_visited).and_return([@ten_visit_conversation, @five_visit_conversation, @one_visit_conversation])
    
    @ten_visit_comment = Factory.create(:comment, {:recent_visits=>10})
    @five_visit_comment = Factory.create(:comment, {:recent_visits=>5})    
    @one_visit_comment = Factory.create(:comment, {:recent_visits=>1})
    Comment.stub(:get_top_visited).and_return([@ten_visit_comment, @five_visit_comment, @one_visit_comment])
    
    @ten_visit_issue = Factory.create(:issue, {:recent_visits=>10})
    @five_visit_issue = Factory.create(:issue, {:recent_visits=>5})    
    @one_visit_issue = Factory.create(:issue, {:recent_visits=>1})
    Issue.stub(:get_top_visited).and_return([@ten_visit_issue, @five_visit_issue, @one_visit_issue])
    
    @ten_visit_question = Factory.create(:question, {:recent_visits=>10})
    @five_visit_question = Factory.create(:question, {:recent_visits=>5})    
    @one_visit_question = Factory.create(:question, {:recent_visits=>1})
    Question.stub(:get_top_visited).and_return([@ten_visit_question, @five_visit_question, @one_visit_question])
    
    @ten_visit_event = Factory.create(:event, {:recent_visits=>10})
    @five_visit_event = Factory.create(:event, {:recent_visits=>5})    
    @one_visit_event = Factory.create(:event, {:recent_visits=>1})
    Event.stub(:get_top_visited).and_return([@ten_visit_event, @five_visit_event, @one_visit_event])
  end
  
  it "should merge all visitable types" do
    result = TopItem.most_visited
    result.include?(@ten_visit_conversation).should == true
    result.include?(@ten_visit_comment).should == true
    result.include?(@ten_visit_issue).should == true
    result.include?(@ten_visit_question).should == true
    result.include?(@ten_visit_event).should == true        
  end  
  
  it "should return the number passed in" do
    result = TopItem.most_visited(5)
    result.count.should == 5
  end
  
  it "should return 10 items if no limit is passed in" do
    result = TopItem.most_visited
    result.count.should == 10
  end
end