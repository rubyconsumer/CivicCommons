require 'spec_helper'

describe Issue do

  before(:all) do
    ActiveRecord::Observer.disable_observers
  end
  after(:all) do
    ActiveRecord::Observer.enable_observers
  end

  def given_3_issues
    @issue1 = Factory.create(:issue, {:created_at => (Time.now - 3.seconds), :updated_at => (Time.now - 3.seconds), :name => 'A first issue'})
    @issue2 = Factory.create(:issue, {:created_at => (Time.now - 2.seconds), :updated_at => (Time.now - 2.seconds), :name => 'Before I had a problem'})
    @issue3 = Factory.create(:issue, {:created_at => (Time.now - 1.second), :updated_at => (Time.now - 1.second), :name => 'Cat in the bag'})
    @person1 = Factory.create(:normal_person)
    @person2 = Factory.create(:normal_person)
    @person3 = Factory.create(:normal_person)

    conversation = Factory.create(:conversation, :issues => [@issue1, @issue2, @issue3])
    @contribution1 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue1)
    @contribution2 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue1)

    @contribution3 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue2)
    @contribution4 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue2)
    @contribution5 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue2)

    @contribution6 = Factory.create(:contribution, :conversation => conversation, :parent => nil, :issue => @issue3)
  end

  def given_an_issue_with_contributions_and_participants
    @issue = Factory.create(:issue)
    @person1 = Factory.create(:normal_person)
    @person2 = Factory.create(:normal_person)
    @person3 = Factory.create(:normal_person)
    @contribution1 = Factory.create(:contribution, :person => @person1, :issue => @issue)
    @contribution2 = Factory.create(:contribution, :person => @person2, :issue => @issue)
    @contribution3 = Factory.create(:contribution, :person => @person2, :issue => @issue)
  end

  def given_an_issue_with_contributions_and_conversations_and_page_visits
    @issue = Factory.create(:issue)
    @contribution = Factory.create(:contribution,:issue => @issue)
    @conversation = Factory.create(:conversation,:issues => [@issue])
    @issue.visits << Factory.create(:visit)
  end

  def given_2_issues_with_contributions_and_visits
    @issue1 = Factory.create(:issue)
    Factory.create(:contribution,:issue => @issue1)
    @issue1.visits << Factory.create(:visit)

    @issue2 = Factory.create(:issue)
    Factory.create(:contribution,:issue => @issue2)
    Factory.create(:contribution,:issue => @issue2)
    @issue2.visits << Factory.create(:visit)
    @issue2.visits << Factory.create(:visit)
  end

  def given_an_issue_with_conversations_and_comments
    @person = Factory.create(:normal_person)
    @issue = Factory.create(:issue)
    @other_issue = Factory.create(:issue)
    @other_conversation = Factory.create(:conversation)

    @conversation = Factory.create(:conversation,:issues => [@issue])
    @comment = Factory.create(:comment, :person => @person, :conversation => @conversation)
  end

  context "validations" do

    let(:attributes) {
      Factory.attributes_for(:issue)
    }

    it "validates a valid object" do
      Issue.new(attributes).should be_valid
    end

    it "requires a name" do
      attributes.delete(:name)
      Issue.new(attributes).should_not be_valid
    end

    it "requires the name to be at least five characters long" do
      attributes[:name] = '1234'
      Issue.new(attributes).should_not be_valid
      attributes[:name] = '12345'
      Issue.new(attributes).should be_valid
    end

    it "requires the name to be unique" do
      mi = Factory.create(:issue)
      attributes[:name] = mi.name
      Issue.new(attributes).should_not be_valid
    end

  end

  context "Top Issues" do

    it "should be determined by total # of contributions to an Issue + total # of page visits." do
      pending
      given_2_issues_with_contributions_and_visits
      Issue.top_issues.should == [@issue2,@issue1]
    end

  end

  context "counters" do
    
    it "should have the correct count of contributions" do
      given_an_issue_with_contributions_and_conversations_and_page_visits
      @issue.contributions.count.should == 1
    end
    
    it "should have the correct count of conversations" do
      given_an_issue_with_contributions_and_conversations_and_page_visits
      @issue.conversations.count.should == 1
    end
    
    it "should have visit counts" do
      given_an_issue_with_contributions_and_conversations_and_page_visits
      @issue.visits.count.should == 1
    end
  
  end
  
  context "with participants" do
    
    it "should have the correct participants" do
      given_an_issue_with_contributions_and_participants
      @issue.participants.should == [@person1,@person2]
    end
    
    it "should have the correct number of participants" do
      given_an_issue_with_contributions_and_participants
      @issue.participants.count.should == 2
    end
  
  end
  
  context "Sort filter" do
    
    it "should sort issue by alphabetical" do
      given_3_issues
      Issue.sort('alphabetical').collect(&:id).should == [@issue1, @issue2, @issue3].collect(&:id)
    end
    
    it "should sort issue by date created" do
      given_3_issues
      Issue.sort('most_recent').collect(&:id).should == [@issue3, @issue2, @issue1].collect(&:id)
    end
    
    it "should sort issue by recently updated" do
      given_3_issues
      @issue1.touch
      Issue.sort('most_recent_update').first.should == @issue1
    end
    
    it "should sort by most active(# of participants and # of contributions)" do
      given_3_issues
      issues = Issue.most_active
      issues.collect(&:id).should == [@issue2.id,@issue1.id,@issue3.id]
    end
    
    it "should sort issue by region" do
      pending
    end
  
  end
  
  context "comments on issues" do
    
    it "should display the correct comments(contribution) that are attached to conversations arround that issues" do
      given_an_issue_with_conversations_and_comments
      @issue.conversation_comments.should == [@comment]
    end
    
    it "should not display other things on comments" do
      given_an_issue_with_conversations_and_comments
      @other_issue.conversation_comments.should == []
    end
  
  end

end
