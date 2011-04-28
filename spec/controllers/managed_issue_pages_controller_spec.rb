require 'spec_helper'

describe ManagedIssuePagesController do

  context "GET show" do

    it "assigns the requested managed issue page as @" do
      page = Factory.create(:managed_issue_page)
      get :show, :issue_id => page.issue.id, :id => page.id
      assigns[:page].should == page
    end

    it "redirects to the issue index page when the requested managed issue page is not found" do
      issue = Factory.create(:issue)
      get :show, :issue_id => issue.id, :id => 'does-not-exist'
      response.should redirect_to issues_path
    end

  end

end
