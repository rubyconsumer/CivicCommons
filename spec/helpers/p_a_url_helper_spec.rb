require 'spec_helper'
require 'cgi'

describe PAUrlHelper do
  describe "pa_new_issue_contribution_url" do

    before(:each) do
      helper.stub!(:pa_authtoken).and_return("&authToken=42")
      @person = Factory.create(:normal_person)
      @issue = Factory.create(:issue)
     
      @generated_url = helper.pa_new_issue_contribution_url(@person, @issue)
    end
    it "should have correct url base" do
      @generated_url.should match /^#{Civiccommons::PeopleAggregator.URL}\/post_content.php?/
    end

    it "should have correct redirect url" do
      url = create_from_pa_contributions_url(:issue_id => @issue.id,
                                             :person_id => @person.id)
      
      @generated_url.should match /redirect=#{CGI.escape(url)}/
    end

    it "should have authtoken param" do
      @generated_url.should match /authToken=42/
    end

    it "should have correct blog_type" do
      @generated_url.should match /blog_type=Contribution/
    end
  end

  describe "pa_new_conversation_contribution_url" do

    before(:each) do
      helper.stub!(:pa_authtoken).and_return("&authToken=42")
      @person = Factory.create(:normal_person)

      @contribution_id = 12
      @conversation_id = 2
     
      @generated_url = helper.
        pa_new_conversation_contribution_url(@person,
                                             @conversation_id,
                                             @contribution_id)
    end
    
    it "should have correct url base" do
      @generated_url.should match /^#{Civiccommons::PeopleAggregator.URL}\/post_content.php?/
    end

    it "should have correct redirect url" do
      url = create_from_pa_contributions_url(:person_id => @person.id,
                                             :conversation_id => @conversation_id,
                                             :parent_contribution_id => @contribution_id)
      
      @generated_url.should match /redirect=#{CGI.escape(url)}/
    end

    it "should have authtoken param" do
      @generated_url.should match /authToken=42/
    end

    it "should have correct blog_type" do
      @generated_url.should match /blog_type=Contribution/
    end
  end
  
end
