require 'spec_helper'

describe Conversation do
  describe "when retrieving all of the issues associated with a conversation" do
    before(:each) do
      @normal_person = Factory.create(:normal_person)
    end
    it "should return issue" do
      conversation = Factory.create(:conversation)
      issue = Factory.create(:issue, :conversations=>[conversation])

      conversation.issues.count.should == 1
      conversation.issues[0].should == issue
    end
  end

  describe "when creating a post for the conversation" do
    before(:each) do
      @comment = Factory.create(:comment)
      @person = Factory.create(:normal_person)
      @conversation = Factory.create(:conversation)
    end

  end
  context "about an issue" do

    it "should sort by the latest updated conversations" do
      issue = Factory.create(:issue, :name => 'A first issue')
      conversation1 = Factory.create(:conversation, {:issues => [issue], :updated_at => (Time.now - 3.seconds)})
      conversation2 = Factory.create(:conversation, {:issues => [issue], :updated_at => (Time.now - 2.seconds)})
      conversation3 = Factory.create(:conversation, {:issues => [issue], :updated_at => (Time.now - 1.second)})
      conversation4 = Factory.create(:conversation)
      conversation2.touch
      issue.conversations.latest_updated.should == [conversation2,conversation3,conversation1]
    end
  end

  describe "when creating several Conversations at once, a la ingester" do
    before(:each) do
      @conversation1 = Factory.create(:conversation)
      @conversation2 = Factory.create(:conversation)
      [@conversation1, @conversation2].each do |conv|
        3.times do
          Factory.create(:top_level_contribution, :conversation => conv)
        end
      end
    end
    it "does not corrupt lft/rgt bounds when earlier conversations are destroyed" do
      @conversation1.destroy

      @conversation2.contributions.collect{|c| p "lft/rgt: #{c.lft} / #{c.rgt}"}
      @conversation2.contributions.collect(&:lft).uniq.size.should == 3
      @conversation2.contributions.collect(&:rgt).uniq.size.should == 3
    end
  end

end
