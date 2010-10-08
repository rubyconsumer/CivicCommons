require 'spec_helper'

describe Contribution do
  Contribution::ALL_TYPES.each do |contribution_type|
    describe "when creating a #{contribution_type} for a conversation" do
      before(:each) do
        @conversation = Factory.create(:conversation)
        @person = Factory.create(:normal_person)
        @top_level_contribution = Factory.create(:top_level_contribution,{:conversation=>@conversation})
        @contribution = contribution_type.constantize.new(
          :content=>"My text.", 
          :person=>@person, 
          :conversation=>@conversation,
          :parent=>@top_level_contribution
        )
        if contribution_type == "AttachedFile"
          @contribution.attachment = File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
        end
        if contribution_type == "Link"
          @contribution.url = "http://www.alfajango.com/"
          @contribution.override_target_doc = "#{Rails.root}/test/fixtures/example_link.html"
          @contribution.override_url_exists = true
        end
        if contribution_type == "EmbeddedSnippet"
          @contribution.url = "http://www.youtube.com/watch?v=djtNtt8jDW4"
          @contribution.override_target_doc = "#{Rails.root}/test/fixtures/example_youtube.html"
          @contribution.override_url_exists = true
        end
      end
      
      context "and there is a validation error with the #{contribution_type}" do
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
      describe "and the #{contribution_type} is saved successfully" do
        before(:each) do
          @contribution.save!
        end
        it "should add the #{contribution_type} to a conversation" do
          @conversation.contributions.count.should == 2
          @conversation.contributions.should include @contribution
        end
        it "should return a #{contribution_type} with no errors" do
          @contribution.errors.count.should == 0
        end  
        it "should set the passed in user as the owner" do
          @contribution.person.should == @person
        end    
        it "should set the item to the conversation" do 
          @contribution.item.should == @conversation
        end
      
        if contribution_type == "Link"
          it "finds the target document" do
            @contribution.target_doc.should_not be_blank
          end
          it "grabs the correct title and description" do
            @contribution.title.should_not be_blank
            @contribution.description.should_not be_blank
            @contribution.title.should match /Pure-CSS Emoticons WordPress Plugin Released - Alfa Jango Blog/
            @contribution.description.should match /I'll keep this post short and sweet. My good friend, Anthony Montalbano, has released a WordPress plugin for our/
          end
        end
        
        if contribution_type == "EmbeddedSnippet"
          it "finds the target document" do
            @contribution.target_doc.should_not be_blank
          end
          it "grabs the correct title and description" do
            @contribution.title.should_not be_blank
            @contribution.description.should_not be_blank
            @contribution.title.should match /YouTube - LeadNuke Demo Screencast/
            @contribution.description.should match /Introduction to LeadNuke.com, featuring demonstration showing how RateMyStudentRental.com uses LeadNuke to increase sales./
          end
          it "creates the right embed code" do
            @contribution.embed_target.should_not be_blank
            @contribution.embed_target.should match /(djtNtt8jDW4)+/
          end
        end
      end
      describe "and accessing the current user's rating for a new (unsaved) record" do
        it "should return nil for user_rating method" do
          @contribution.new_record?.should be_true
          @contribution.user_rating.should be_nil
        end
      end
      describe "and accessing the current user's rating for a record loaded from ActiveRecord" do
        before(:each) do
          @contribution.save!
          @contributions = Contribution.scoped
        end
        context "when NOT using the `with_user_rating(user)` scope to load the record" do
          it "should return nil for user_rating" do
            scoped_contribution = @contributions.first
            scoped_contribution.user_rating.should be_nil
          end
        end
        context "when using the `with_user_rating(user)` scope to load the record" do
          it "should return nil if the user has not rated it" do
            scoped_contribution = @contributions.with_user_rating(@person).first
            scoped_contribution.user_rating.should be_nil
          end
          it "should return the user's rating if the user has rated it" do
            @contribution.rate!(-1,@person)
            @contribution.user_rating.should_not be_nil
            scoped_contribution = @contributions.with_user_rating(@person).find(@contribution)
            scoped_contribution.id.should == @contribution.id
            scoped_contribution.user_rating.should == "-1"
          end
          it "should load all records, even ones the user has not rated (ensures proper joins type used in scope)" do
            contribution_2 = Factory.create(contribution_type.underscore.to_sym)
            scoped_contributions = @contributions.with_user_rating(@person).all
            scoped_contributions.include?(@contribution).should == true
            scoped_contributions.include?(contribution_2).should == true
          end
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
