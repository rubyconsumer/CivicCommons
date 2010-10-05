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
          @contribution.title = "Some title"
          @contribution.description = "Very good description"
        end
        if contribution_type == "EmbeddedSnippet"
          @contribution.url = "http://www.youtube.com/watch?v=djtNtt8jDW4"
          @contribution.title = "Some title"
          @contribution.description = "Very good description"
          @contribution.embed_target = "<object width='320' height='192'><param name='movie' value='http://www.youtube.com/v/djtNtt8jDW4?fs=1&amp;hl=en_US'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='http://www.youtube.com/v/djtNtt8jDW4?fs=1&amp;hl=en_US' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='320' height='192'></embed></object>"
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
      context "and the #{contribution_type} saves successfully" do
        it "should add the #{contribution_type} to a conversation" do
          @contribution.save!
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
