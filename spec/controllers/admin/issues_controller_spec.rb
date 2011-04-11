require 'spec_helper'

module Admin
  describe IssuesController do

    before :each do
      @admin_person = Factory.create(:admin_person)
      @controller.stub(:current_person).and_return(@admin_person)
    end

    describe "GET: index" do
      
      it "assigns a collection of issues to @issues" do
        issues = [mock_model(Issue)]
        Issue.should_receive(:all).and_return(issues)

        get :index
        assigns(:issues).should == issues
      end

    end

    describe "GET: new" do
      
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

        it "sets @issue to a new instance of issue" do
          issue = mock_model(Issue)
          Issue.should_receive(:new).and_return(issue)
          issue.stub(:save).and_return(false)

          post :create
          assigns(:issue).should == issue
        end

        it "renders the new action" do
          issue = mock('issue')
          Issue.stub(:new).and_return(issue)
          issue.should_receive(:save).and_return(false)

          post :create
          response.should render_template('issues/new')
        end

      end

    end

    describe "GET: show" do

      it "assigns an existing instance of Issue to @issue" do
        issue = Factory.build(:issue)
        Issue.should_receive(:find).with(1).and_return(issue)

        get :show, id: 1
        assigns(:issue).should == issue
      end

    end

    describe "GET: edit" do
      
      it "assigns an existing instance of Issue to @issue" do
        issue = Factory.build(:issue)
        Issue.should_receive(:find).with(1).and_return(issue)

        get :edit, id: 1
        assigns(:issue).should == issue
      end

      it "renders the new issue template" do
        issue = Factory.build(:issue)
        Issue.stub(:find).with(1).and_return(issue)

        get :edit, id: 1
        response.should render_template('issues/edit')
      end

    end

    describe "PUT: update" do

      context "Valid Issue" do
        
        it "updates an instance of Issue with the params from the form" do
          issue = mock_model(Issue, name: 'This is the changed name for a valid issue')
          Issue.should_receive(:find).with(1).and_return(issue)
          issue.stub(:update_attributes).and_return(true)

          put :update, id: 1
          assigns(:issue).should == issue
        end

        it "redirects to the admin issue path on successful update" do
          issue = mock_model(Issue)
          Issue.stub(:find).with(1).and_return(issue)
          issue.should_receive(:update_attributes).and_return(true)

          put :update, id: 1
          response.should redirect_to admin_issues_path
        end

        it "sets flash notice" do
          issue = mock("issue")
          Issue.stub(:find).with(1).and_return(issue)
          issue.stub(:update_attributes).and_return(true)

          put :update, id: 1
          flash[:notice].should_not be_nil
          flash[:notice].should == "Thank you for updating the issue"
        end

      end

      context "Invalid Attributes" do

        it "sets @issue to a new instance of issue" do
          issue = mock_model(Issue)
          Issue.should_receive(:find).with(1).and_return(issue)
          issue.stub(:update_attributes).and_return(false)

          put :update, id: 1
          assigns(:issue).should == issue
        end

        it "renders the edit action" do
          issue = mock('issue')
          Issue.stub(:find).with(1).and_return(issue)
          issue.stub(:update_attributes).and_return(false)

          put :update, id: 1
          response.should render_template('issues/edit')
        end

      end

    end

    describe "DELETE: destroy" do

      it "sets @issue to the item being deleted" do
        issue = mock_model(Issue)
        Issue.should_receive(:find).with(1).and_return(issue)

        delete :destroy, id: 1
        assigns(:issue).should == issue
      end   

      it "removed the item from the db" do
        issue = Factory.create(:issue)
        issue_count = Issue.count
        issue_count.should == 1
        Issue.stub(:find).with(1).and_return(issue)

        delete :destroy, id: 1
        updated_count = Issue.count
        updated_count.should == 0 
      end

      it "redirects to the admin issues path" do
        issue = mock_model(Issue)
        Issue.stub(:find).with(1).and_return(issue)
        issue.stub(:destroy).and_return(issue)

        delete :destroy, id: 1
        response.should redirect_to(admin_issues_path)
      end   

    end
    
  end

end
