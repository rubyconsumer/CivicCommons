require 'spec_helper'

describe IssuesController do

  def mock_issue(stubs={})
    @mock_issue ||= mock_model(Issue)
  end

  describe "GET index" do
    it "assigns all issues as @issues" do
      issues = [mock_issue]
      search = mock("search")
      Issue.should_receive(:sort).and_return(search)
      search.should_receive(:paginate).and_return(issues)

      get :index
      assigns(:issues).should == issues
    end

    it "assigns all regions to @regions" do
      regions = [mock_model(Region)]
      Region.should_receive(:all).and_return(regions)

      get :index
      assigns(:regions).should == regions
    end

    it "assigns the first main article to @main_article" do
      article = mock_model(Article)
      article_collection = [article]
      Article.should_receive(:issue_main_article).and_return(article_collection)
      article_collection.should_receive(:first).and_return(article)

      get :index
      assigns(:main_article).should == article 
    end

    it "assigns  3 articles to @sub_articles" do
      article1, article2, article3 = mock_model(Article), mock_model(Article), mock_model(Article)
      articles = []
      article_collection = [article1, article2, article3]
      Article.should_receive(:issue_sub_articles).and_return(articles)
      articles.should_receive(:limit).with(3).and_return(article_collection)

      get :index
      assigns(:sub_articles).should == article_collection
    end

    it "assigns 3 top items to @recent_items" do
      item1, item2, item3 = mock_model(TopItem), mock_model(TopItem), mock_model(TopItem)
      recent_items_collection = [item1, item2, item3]
      TopItem.should_receive(:newest_items).with(3).and_return(recent_items_collection)
      recent_items_collection.should_receive(:for).with(:issue).and_return(recent_items_collection)
      recent_items_collection.should_receive(:collect).at_least(:once).and_return(recent_items_collection)

      get :index
      assigns(:recent_items).should == recent_items_collection
    end

  end

  describe "GET show" do

    before(:each) do
      @person = Factory.create(:normal_person)
      @controller.stub(:current_person).and_return(@person)
    end

    it "assigns the requested issue as @issue" do
      pending
      issue = mock('issue')
      issue.stub!(:find).with("37").and_return(@issue)
      get :show, :id => "37"
      assigns(:issue).should be @issue
    end

    it "records a visit to the issue passing the current user" do
      pending
      issue = mock('issue')
      issue.stub!(:find).with("37") {mock_issue}
      mock_issue.should_receive(:visit!).with(@person.id)
      get :show, :id => "37"
    end

  end

end
