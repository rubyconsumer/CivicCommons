require 'spec_helper'

module Admin
  describe IssuesController do

    before :each do
      @admin_person = Factory.create(:admin_person)
      @controller.stub(:current_person).and_return(@admin_person)
    end

    describe "GET: Index" do
      
      it "assigns a collection of issues to @issues" do
        issues = [mock_model(Issue)]
        Issue.should_receive(:all).and_return(issues)

        get :index
        assigns(:issues).should == issues
      end

    end

    describe "GET: Show" do
      
      it "assigns a new instance of Issue to @issue" do
        issue = mock_model(Issue)
        Issue.should_receive(:new).and_return(issue)
        
        get :new
        assigns(:issue).should == issue
      end

    end

    describe "POST: create" do
      
      context "Valid Issue" do
        
        it "creates a new instance of Issue with the params from the form" do
          issue = mock_model(Issue, name: 'This is a valid issue')
          Issue.stub(:new).and_return(issue)
          issue.stub(:save).and_return(true)

          post :create
          assigns(:issue).should == issue
        end

        it "redirects to the admin issue path on successful save" do
          issue = mock_model(Issue)
          Issue.stub(:new).and_return(issue)
          issue.should_receive(:save).and_return(true)

          post :create
          response.should redirect_to admin_issues_path
        end

        it "sets flash notice" do
          issue = mock("issue")
          Issue.stub(:new).and_return(issue)
          issue.stub(:save).and_return(true)

          post :create
          flash[:notice].should_not be_nil
          flash[:notice].should == "Thank you for submitting an issue"
        end

      end

      context "Invalid Attributes" do

      end

    end

  end

end
  
