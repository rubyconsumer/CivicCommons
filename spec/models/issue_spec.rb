require 'spec_helper'

describe Issue do
  def given_3_issues
    @issue1 = Factory.create(:issue, {:created_at => (Time.now - 3.seconds), :updated_at => (Time.now - 3.seconds), :name => 'A first issue'})
    @issue2 = Factory.create(:issue, {:created_at => (Time.now - 2.seconds), :updated_at => (Time.now - 2.seconds), :name => 'Before I had a problem'})
    @issue3 = Factory.create(:issue, {:created_at => (Time.now - 1.second), :updated_at => (Time.now - 1.second), :name => 'Cat in the bag'})
    @person1 = Factory.create(:normal_person)
    @person2 = Factory.create(:normal_person)
    @person3 = Factory.create(:normal_person)
    @conversation1 = Factory.create(:conversation,:guides => [@person1,@person2],:issues => [@issue2])
    @conversation2 = Factory.create(:conversation,:guides => [@person1],:issues => [@issue2])
    @conversation3 = Factory.create(:conversation,:guides => [@person1],:issues => [@issue1])
    @contribution = Factory.create(:contribution,:issue => @issue2)
  end
  def given_an_issue_with_conversations_and_participants
    @issue = Factory.create(:issue)
    @person1 = Factory.create(:normal_person)
    @person2 = Factory.create(:normal_person)
    @person3 = Factory.create(:normal_person)
    @conversation1 = Factory.create(:conversation,:guides => [@person1,@person2],:issues => [@issue])
    @conversation2 = Factory.create(:conversation,:guides => [@person1],:issues => [@issue])
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
  context "Top Issues" do
    it "should be determined by total # of contributions to an Issue + total # of page visits." do
      pending
      given_2_issues_with_contributions_and_visits
      Issue.top_issues.should == [@issue2,@issue1]
    end  
  end
  context "Featured Issues" do
    it "are editorially set." do
      pending
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
      given_an_issue_with_conversations_and_participants
      @issue.participants.should == [@person1,@person2]
    end
    it "should have the correct number of participants" do
      given_an_issue_with_conversations_and_participants
      #there's gotta be a better way than this below
      @issue.participants.count('DISTINCT(people.id)').should == 2
    end
  end
  context "Sort filter" do
    it "should sort issue by alphabetical" do
      given_3_issues
      Issue.sort('alphabetical').should == [@issue1, @issue2, @issue3]
    end
    it "should sort issue by date created" do
      given_3_issues
      Issue.sort('most_recent').should == [@issue3, @issue2, @issue1]
    end
    it "should sort issue by recently updated" do
      given_3_issues
      @issue1.touch
      Issue.sort('most_recent_update').first.should == @issue1
    end
    it "should sort by hotness(# of participants and # of contributions)" do
      given_3_issues
      issues = Issue.most_hot
      issues.collect(&:id).should == [@issue2.id,@issue1.id,@issue3.id]
    end
    it "should sort issue by region" do
      pending
    end
  end
end
