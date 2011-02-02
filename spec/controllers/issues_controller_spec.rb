require 'spec_helper'

describe IssuesController do
  def mock_issue(stubs={})
    @mock_issue ||= mock_model(Issue, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all issues as @issues" do
      result = [mock_issue]
      Issue.stub(:sort).and_return(result)
      result.stub(:all).and_return(result)

      get :index
      assigns(:issues).should == [mock_issue]
    end
  end

  describe "GET show" do
    before(:each) do
      @person = Factory.create(:normal_person)
      @controller.stub(:current_person).and_return(@person)
    end
    it "assigns the requested issue as @issue" do
      Issue.stub(:find).with("37") { mock_issue }
      get :show, :id => "37"
      assigns(:issue).should be(mock_issue)
    end
    it "records a visit to the issue passing the current user" do
      Issue.stub(:find).with("37") { mock_issue }
      mock_issue.should_receive(:visit!).with(@person.id)
      get :show, :id => "37"
    end
  end

end
