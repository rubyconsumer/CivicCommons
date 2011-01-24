require 'spec_helper'

describe Conversation do
  it { should have_many :contributions  }
  it { should have_attached_file :image }
end

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

  describe "when creating several Conversations at once" do
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

      #@conversation2.contributions.collect{|c| p "lft/rgt: #{c.lft} / #{c.rgt}"}
      @conversation2.contributions.collect(&:lft).uniq.size.should == @conversation2.contributions.size
      @conversation2.contributions.collect(&:rgt).uniq.size.should == @conversation2.contributions.size
    end
    it "destroyes contributions when conversation is destroyed" do
      contribution_ids = @conversation1.contributions.collect(&:id)
      @conversation1.destroy
      Contribution.where(:id => contribution_ids).count.should == 0
    end
    it "does not destroy contributions from other conversations when conversation is destroyed" do
      size = @conversation2.contributions.size
      @conversation1.destroy
      @conversation2.contributions.size.should == size
    end
  end

  describe "when destroying a conversation" do
    before(:each) do
      @conversation = Factory.create(:conversation)
      @contribution = Factory.create(:contribution, :conversation => @conversation, :parent => nil)
      @top_level_contribution = Factory.create(:top_level_contribution, :conversation => @conversation)
      @nested_contribution = Factory.create(:contribution, :parent => @top_level_contribution, :conversation => @conversation)
    end
    it "destroys all nested contributions" do
      contribution_ids = [ @contribution,
        @top_level_contribution,
        @nested_contribution
      ].collect(&:id)
      @conversation.destroy
      Contribution.where(:id => contribution_ids).count.should == 0
    end
    it "destroys all top_items from nested contributions" do
      item_ids = @conversation.contributions.includes(:top_item).collect{ |c| c.top_item.id }
      @conversation.destroy
      TopItem.where(:id => item_ids).count.should == 0
    end
  end
end
