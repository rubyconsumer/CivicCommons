require 'spec_helper'

describe Conversation do
  it { should have_many :contributions  }
  it { should have_attached_file :image }
end

describe Conversation do
  describe "a valid conversation" do
    before :each do
      @conversation = Factory.build(:conversation)
    end
    it "is invalid with no title" do
      @conversation.title = nil
      @conversation.should have_validation_error(:title)
    end
    it "is invalid with no zip code" do
      @conversation.zip_code = nil
      @conversation.should have_validation_error(:zip_code)
    end
    it "is invalid with no summary" do
      @conversation.summary = nil
      @conversation.should have_validation_error(:summary)
    end
  end

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

  describe "when filtering conversations" do
    Conversation.available_filter_names.each do |filter_name|
      it "filters by :#{filter_name} by grabbing the appropriate named scope and doesn't raise error" do
        Conversation.should_receive(Conversation.available_filters[filter_name.to_sym])
        lambda { Conversation.filtered(filter_name) }.should_not raise_error
      end
    end
  end

  describe "when creating a user-generated conversation" do
    before(:each) do
      @person = Factory.build(:normal_person)

      @contributions = {
        "0" => Factory.build(:comment, :owner => @person.id, :conversation => nil, :parent => nil).attributes,
        "1" => Question.new.attributes,
        "2" => AttachedFile.new.attributes,
        "3" => Link.new.attributes,
        "4" => EmbeddedSnippet.new.attributes,
        "5" => SuggestedAction.new.attributes
      }

      build_conversation(@contributions)
    end

    def build_conversation(attributes)
      # Need to deep clone @contributions so we can preserve original hash of attributes above
      # when Contribution.setup_node_level_contribution modifies the attribute objects in the hash
      # (i.e. shallow cloning with #clone or #dup won't suffice
      attributes = Marshal::load(Marshal.dump(attributes))
      @conversation = Factory.build(:user_generated_conversation, :person => @person, :contributions_attributes => attributes)
    end

    it "raises an error if conversation created without owner" do
      @conversation.person = nil
      @conversation.save
      @conversation.should have_validation_error(:person)
    end

    it "filters out all invalid contributions (i.e. blank contributions from contribution form) before save" do
      @conversation.save
      @conversation.errors.should be_empty
      @conversation.contributions.size.should == 1
    end

    it "raises an error if conversation created with multiple contributions" do
      @contributions["1"] = Factory.build(:question, :conversation => nil, :parent => nil).attributes
      build_conversation(@contributions)
      @conversation.save
      @conversation.should have_validation_error(:contributions)
    end

    it "raises error if conversation created with no contributions" do
      @contributions["0"] = Comment.new.attributes
      build_conversation(@contributions)
      @conversation.save
      @conversation.should have_validation_error(:contributions)
    end

    it "raises error if conversation created with no associated issues" do
      @conversation.issues = []
      @conversation.should have_validation_error(:issues)
    end
  end
end
