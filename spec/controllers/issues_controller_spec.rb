require 'spec_helper'

describe IssuesController do

  describe "GET index" do

    before(:each) do

      (1..2).each do
        Factory.create(:issue)
      end

      (1..2).each do
        Factory.create(:managed_issue)
      end

      (1..2).each do
        Factory.create(:issue, :exclude_from_result => true)
      end

    end

    it "assigns all issues as @issues" do
      get :index
      assigns(:issues).should == Issue.where(:type => 'Issue').where(:exclude_from_result => false).all
    end

    it "assigns items to @recent_items" do
      item = mock_model(Contribution)
      activity = mock_model(Activity)
      Activity.should_receive(:most_recent_activity_items).and_return([item])
      get :index

      assigns(:recent_items).should == [item]
    end

  end

  describe "GET show" do

    context "with standard issues" do

      before(:each) do
        @user = Factory.create(:registered_user)
        sign_in @user
        @issue = Factory.create(:issue)
      end

      it "assigns the requested issue as @issue" do
        get :show, :id => @issue.id
        assigns(:issue).should == @issue
      end

      it "records a visit to the issue passing the current user" do
        count_before = Visit.where(:person_id => @user.id).where(:visitable_id => @issue.id).where(:visitable_type => "Issue").size
        get :show, :id => @issue.id
        count_after = Visit.where(:person_id => @user.id).where(:visitable_id => @issue.id).where(:visitable_type => "Issue").size
        count_after.should == count_before + 1
      end

    end

    context "with managed issues (aka Projects)" do

      let(:issue) do
        Factory.create(:managed_issue)
      end

      it "renders the index managed issue page when set" do
        issue.index = Factory.create(:managed_issue_page, issue: issue)
        issue.save
        get :show, :id => issue.id
        response.should render_template 'managed_issue_pages/show'
      end

      it "renders the standard show page when index page not set" do
        get :show, :id => issue.id
        response.should render_template 'show'
      end

    end

  end

end
