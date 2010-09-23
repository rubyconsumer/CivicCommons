require File.dirname(__FILE__) + '/../spec_helper'

describe TopItem, "when retrieving the top items by date" do
  before(:each) do
    @seven_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 7.days)})
    @three_day_conversation = Factory.create(:conversation, {:created_at=>(Time.now - 3.days)})    
    @today_conversation = Factory.create(:conversation, {:created_at=>Time.now})    
    @seven_day_contribution = Factory.create(:top_level_contribution, {:created_at=>(Time.now-7.days)})
    @three_day_contribution = Factory.create(:top_level_contribution, {:created_at=>(Time.now-3.days)})
    @today_contribution = Factory.create(:top_level_contribution, {:created_at=>Time.now})
    @seven_day_issue = Factory.create(:issue, {:conversations=>[@seven_day_conversation], :created_at=>(Time.now - 7.days)})
    @three_day_issue = Factory.create(:issue, {:conversations=>[@three_day_conversation], :created_at=>(Time.now - 3.days)})
    @today_issue = Factory.create(:issue, {:conversations=>[@today_conversation], :created_at=>Time.now})
    @seven_day_event = Factory.create(:event, {:conversations=>[@seven_day_conversation], :created_at=>(Time.now - 7.days)})
    @three_day_event = Factory.create(:event, {:conversations=>[@three_day_conversation], :created_at=>(Time.now - 3.days)})
    @today_event = Factory.create(:event, {:conversations=>[@today_conversation], :created_at=>Time.now})
  end
  
  it "should return the number passed in" do
    result = TopItem.newest_items(5)
    result.count.should == 5
  end
  
  it "should return 10 items if no limit is passed in" do
    result = TopItem.newest_items
    result.count.should == 10
  end
  
  it "should merge top itemable items" do
    result = TopItem.newest_items.includes(:item)
    items = result.collect{ |ti| ti.item }
    old_top_items = TopItem.order("item_created_at ASC").includes(:item).limit(TopItem.count - 10)

    items.include?(@today_conversation).should == true
    items.include?(@today_contribution).should == true
    items.include?(@today_issue).should == true
    items.include?(@today_event).should == true
    
    # old_top_items.each do |oti|                     # <= Please don't do stuff like this. I'm leaving this in here for educational purposes. You can't do this, because 4 items all have the same created_at timestamp
    #   items.include?(oti.item).should == false      #     and MySQL is not consistent about which 2 of the 4 latest items will be included in TopItems.newest_items. This is not a bug, just a trivial and unrealistic
    # end                                             #     test that there is no reason to have a spec for.
  end  
  
end

describe TopItem, "when retrieving the top items by rating" do
  before(:each) do
    @ten_rating_conversation = Factory.create(:conversation, {:recent_rating=>10})
    @five_rating_conversation = Factory.create(:conversation, {:recent_rating=>5})    
    @one_rating_conversation = Factory.create(:conversation, {:recent_rating=>1})    
    Conversation.stub(:get_top_rated).and_return([@ten_rating_conversation, @five_rating_conversation, @one_rating_conversation])
    
    @ten_rating_issue = Factory.create(:issue, {:recent_rating=>10})
    @five_rating_issue = Factory.create(:issue, {:recent_rating=>5})    
    @one_rating_issue = Factory.create(:issue, {:recent_rating=>1})
    Issue.stub(:get_top_rated).and_return([@ten_rating_issue, @five_rating_issue, @one_rating_issue])
    
    @ten_rating_event = Factory.create(:event, {:recent_rating=>10})
    @five_rating_event = Factory.create(:event, {:recent_rating=>5})    
    @one_rating_event = Factory.create(:event, {:recent_rating=>1})
    Event.stub(:get_top_rated).and_return([@ten_rating_event, @five_rating_event, @one_rating_event])

    @ten_rating_contribution = Factory.create(:contribution, {:recent_rating=>10})
    @five_rating_contribution = Factory.create(:contribution, {:recent_rating=>5})    
    @one_rating_contribution = Factory.create(:contribution, {:recent_rating=>1})
    Comment.stub(:get_top_rated).and_return([@ten_rating_contribution, @five_rating_contribution, @one_rating_contribution])

  end
  
  it "should merge all rateable types" do
    result = TopItem.highest_rated
    items = result.collect{ |ti| ti.item }
    
    items.include?(@ten_rating_conversation).should == true
    items.include?(@ten_rating_contribution).should == true
    items.include?(@ten_rating_issue).should == true
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
    
    @ten_visit_contribution = Factory.create(:contribution, {:recent_visits=>10})
    @five_visit_contribution = Factory.create(:contribution, {:recent_visits=>5})    
    @one_visit_contribution = Factory.create(:contribution, {:recent_visits=>1})
    Comment.stub(:get_top_visited).and_return([@ten_visit_contribution, @five_visit_contribution, @one_visit_contribution])
    
    @ten_visit_issue = Factory.create(:issue, {:recent_visits=>10})
    @five_visit_issue = Factory.create(:issue, {:recent_visits=>5})    
    @one_visit_issue = Factory.create(:issue, {:recent_visits=>1})
    Issue.stub(:get_top_visited).and_return([@ten_visit_issue, @five_visit_issue, @one_visit_issue])
    
    @ten_visit_event = Factory.create(:event, {:recent_visits=>10})
    @five_visit_event = Factory.create(:event, {:recent_visits=>5})    
    @one_visit_event = Factory.create(:event, {:recent_visits=>1})
    Event.stub(:get_top_visited).and_return([@ten_visit_event, @five_visit_event, @one_visit_event])
  end
  
  it "should merge all visitable types" do
    result = TopItem.most_visited
    items = result.collect{ |ti| ti.item }
    
    items.include?(@ten_visit_conversation).should == true
    items.include?(@ten_visit_contribution).should == true
    items.include?(@ten_visit_issue).should == true
    items.include?(@ten_visit_event).should == true        
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