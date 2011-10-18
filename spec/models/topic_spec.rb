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
end