require 'spec_helper'

describe Contribution do
  describe "when creating a TopLevelContribution for a conversation" do
    before(:each) do
      @top_level_contribution = Factory.build(:top_level_contribution)
      @top_level_contribution.run_callbacks(:save)
    end
    it "sets confirmed = true by default" do
      @top_level_contribution.confirmed.should be_true
    end
  end
  describe "when confirming contributions" do
    before(:each) do
      @contribution = Factory.create(:contribution, {:override_confirmed => false})
    end
    it "omits unconfirmed contributions (those only previewed but never confirmed) in confirmed scope" do
      contributions = Contribution.confirmed.all
      contributions.should_not include @contribution
    end
    it "returns only unconfirmed contributions for unconfirmed scope" do
      contributions = Contribution.unconfirmed.all
      contributions.should include @contribution
    end
    it "successfully sets :confirmed to true with .confirm! method and saves to database" do
      @contribution.confirm!
      @contribution.confirmed.should be_true
      contribution = Contribution.confirmed.find(@contribution.id)
      contribution.confirmed.should be_true
    end
  end
  describe "when deleting old unconfirmed contributions" do
    before(:each) do
      @old_unconfirmed_contribution = Factory.create(:comment, {:created_at => Time.now - 3.days, :confirmed => false})
      @new_unconfirmed_contribution = Factory.create(:comment, {:created_at => Time.now, :confirmed => false})
      @old_confirmed_contribution = Factory.create(:comment, {:created_at => Time.now - 3.days, :override_confirmed => true})
      @new_confirmed_contribution = Factory.create(:comment, {:created_at => Time.now, :override_confirmed => true})
      @count = Contribution.delete_old_unconfirmed_contributions
      @remaining_contributions = Contribution.all
    end
    it "returns correct number of deleted contributions" do
      @count.should == 1
    end
    it "deletes old unconfirmed contributions" do
      @remaining_contributions.should_not include @old_unconfirmed_contribution
    end
    it "does not delete unconfirmed contributions newer than 1 day" do
      @remaining_contributions.should include @new_unconfirmed_contribution
    end
    it "does not delete confirmed contributions" do
      @remaining_contributions.should include @old_confirmed_contribution
      @remaining_contributions.should include @new_confirmed_contribution
    end
  end
  Contribution::ALL_TYPES.each do |contribution_type|
    describe contribution_type, "when creating for a conversation" do
      before(:each) do
        @conversation = Factory.create(:conversation)
        @person = Factory.create(:normal_person)
        @top_level_contribution = Factory.create(:top_level_contribution,{:conversation=>@conversation})
        @contribution = Factory.build(contribution_type.underscore.to_sym, {
          :person=>@person, 
          :conversation=>@conversation,
          :parent=>@top_level_contribution 
        } )
      end
      
      context "and there is a validation error" do
        it "should return a contribution with an error" do
          @contribution.content = nil
          @contribution.url = nil
          if ["Link","EmbeddedSnippet"].include?(@contribution.type)
            @contribution.should have_validation_error(:url)
          else
            @contribution.should have_validation_error(:content)
          end
        end
      end
      describe "when it is saved for preview" do
        before(:each) do
          # @contribution.run_callbacks(:save) # this does not work with awesome_nested_set apparently
          @contribution.save!
        end
        it "saves with :confirmed set to false" do
          @contribution.confirmed.should be_false
        end
        it "should set the passed in user as the owner" do
          @contribution.person.should == @person
        end    
        it "should set the item to the conversation" do 
          @contribution.item.should == @conversation
        end
      end
      describe "and using node level contribution methods" do
        before(:each) do
          @attributes = Factory.attributes_for(contribution_type.underscore).merge({
            :parent_id => @contribution.parent_id,
            :type => contribution_type,
            :conversation => @contribution.conversation
          })
        end
        context "when using Contribution.new_node_level_contribution" do
          it "sets up a valid #{contribution_type} but doesn't save it to the db" do
            contribution = Contribution.new_node_level_contribution(@attributes, @person)
            contribution.class.to_s.should == contribution_type.to_s
            contribution.valid?.should be_true
            contribution.new_record?.should be_true
          end
        end
        context "when using Contribution.create_node_level_contribution" do
          it "sets up and creates a valid #{contribution_type} saved to the db" do
            contribution = Contribution.create_node_level_contribution(@attributes, @person)
            contribution.class.to_s.should == contribution_type.to_s
            contribution.valid?.should be_true
            contribution.new_record?.should be_false
          end
        end
        describe "dealing with preview functionality" do
          before(:each) do 
            @contribution.save!
          end
          context "when using Contribution.find_or_create_node_level_contribution" do
            it "finds and returns unconfirmed contribution for user/parent combination, if it exists, but with new content" do
              new_comment = "This is a different comment"
              attributes = @attributes.merge(:content => new_comment)
              new_contribution = Contribution.update_or_create_node_level_contribution(attributes, @person)
              new_contribution.id.should == @contribution.id
              new_contribution.content.should == new_comment
            end
            it "creates and returns a new contribution if no unconfirmed contribution exists for user/parent combination" do
              attributes = @attributes.merge(:parent_id => (@contribution.parent_id + 1))
              new_contribution = Contribution.update_or_create_node_level_contribution(attributes, @person)
              new_contribution.id.should_not == @contribution.id
            end
          end
        end
      end
      describe "and it is saved successfully" do
        before(:each) do
          @contribution.override_confirmed = true
          @contribution.save!
        end
        it "should add the #{contribution_type} to a conversation" do
          @conversation.contributions.count.should == 2
          @conversation.contributions.should include @contribution
        end
      end
    end
  end
  
  describe "when creating a contribution for an issue" do
    before(:each) do
      @issue = Factory.create(:issue)
      @mock_person = Factory.create(:normal_person)      
    end
    it "should set the item to the issue" do 
      contribution = Contribution.create({:issue=>@issue, :person=>@mock_person, :content=>"Hello World"})
      contribution.item.should == @issue
    end
  end
  describe "validating a contribution" do
    it "should require an issue or a contributiion" do
      person = Factory.create(:normal_person)
      contribution = Contribution.
        create_node_level_contribution({:content => "Foo Bar",
                                         :type => "Comment"},
                                       person)
      contribution.errors.count.should == 1
    end
  end

  describe "validating a contribution for an issue" do
    before(:each) do
      @issue = Factory.create(:issue)
      @person = Factory.create(:normal_person)
    end

    it "should be valid when creating a Comment" do
      contribution = Contribution.
        create_node_level_contribution({:issue_id => @issue.id,
                                         :content => "Foo Bar",
                                         :type => "Comment"},
                                       @person)
      contribution.valid?.should be_true
    end

    it "should not be valid without a person" do
      contribution = Contribution.
        create_node_level_contribution({:issue_id => @issue.id,
                                         :content => "Foo Bar",
                                         :type => "Comment"}, nil)
      contribution.valid?.should be_false
    end
  end
end
