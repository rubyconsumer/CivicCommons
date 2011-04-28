require 'spec_helper'

describe IssuesController do

  def mock_issue(stubs={})
    @mock_issue ||= mock_model(Issue)
  end

  describe "GET index" do

    before(:each) do

      (1..2).each do
        Factory.create(:issue)
      end

      (1..2).each do
        Factory.create(:region)
      end

      @main_article = Factory.create(:article, :current => true, :issue_article => true, :main => true)
      @sub_articles = []
      (1..2).each do
        @sub_articles << Factory.create(:article, :current => true, :issue_article => true, :main => false)
      end

    end

    it "assigns all issues as @issues" do
      get :index
      assigns(:issues).should == Issue.all
    end

    it "assigns all regions to @regions" do
      get :index
      assigns(:regions).should == Region.all
    end

    it "assigns the first main article to @main_article" do
      get :index
      assigns(:main_article).should == @main_article
    end

    it "assigns all articles to @sub_articles" do
      get :index
      assigns(:sub_articles).collect # because of active record lazy loading
      assigns(:sub_articles).first.should be_instance_of Article
      assigns(:sub_articles).size.should == @sub_articles.size
    end

    it "assigns all top items to @recent_items" do
      get :index
      assigns(:recent_items).collect # because of active record lazy loading
      assigns(:recent_items).first.should be_kind_of TopItemable
      assigns(:recent_items).should_not be_empty
    end

  end

  describe "GET show" do

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

end
