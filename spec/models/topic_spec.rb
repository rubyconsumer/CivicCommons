require 'spec_helper'

describe Topic do
  describe "validation" do
    it "should validate presence of name" do
      should validate_presence_of(:name)
    end
    it "should validate uniqueness of name" do
      Factory.create(:topic)
      should validate_uniqueness_of(:name)
    end
  end
  describe "Associations" do
    context "has_and_belongs_to_many issues" do
      def given_a_topic_with_issues
        @topic = Factory.create(:topic)
        @issue1 = Factory.create(:issue)
        @issue2 = Factory.create(:issue)
        @topic.issues = [@issue1, @issue2]
      end
      it "should be correct" do
        Topic.reflect_on_association(:issues).macro.should == :has_and_belongs_to_many
      end
      it "should correctly count the number of topics" do
        given_a_topic_with_issues
        @topic.issues.count.should == 2
      end
    end
  end
  describe "For Sidebar" do
    def given_topics_with_issues_for_sidebar
      @topic1 = Factory.create(:topic)
      @topic2 = Factory.create(:topic)
      @issue1 = Factory.create(:issue, :topics => [@topic1], :exclude_from_result=> true)
      @issue2 = Factory.create(:issue, :topics => [@topic1], :exclude_from_result=> false)
      @issue2 = Factory.create(:issue, :topics => [@topic1], :exclude_from_result=> false)
      @managed_issue1 = Factory.create(:managed_issue, :topics => [@topic1], :exclude_from_result=> false)
      
      @topic_result = Topic.including_public_issues.first
      Topic.including_public_issues.length.should == 1
    end
    it "should return topics that has an issue count of 1(one) or more" do
      given_topics_with_issues_for_sidebar
      @topic_result.issue_count == 1
    end
    it "should return only Issue type" do
      given_topics_with_issues_for_sidebar
      @topic_result.issues.first.type == 'Issue'
    end
    it "should only return issues where exclude_from_result = false" do
      @topic = Factory.create(:topic)
      @issue = Factory.create(:issue, :topics => [@topic], :exclude_from_result=> false)
      Topic.including_public_issues.length.should == 1
    end
    it "should not return anything when issues are exclude_from_result = true" do
      @topic = Factory.create(:topic)
      @issue = Factory.create(:issue, :topics => [@topic], :exclude_from_result=> true)
      Topic.including_public_issues.length.should == 0
    end
    it "should have issue_count as an additional select field" do
      given_topics_with_issues_for_sidebar
      @topic_result.respond_to?(:issue_count).should be_true
    end
  end
end