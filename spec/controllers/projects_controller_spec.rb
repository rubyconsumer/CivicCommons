require 'spec_helper'

describe ProjectsController do

  describe "GET index" do

    before(:each) do

      (1..2).each do
        Factory.create(:issue)
      end

      (1..2).each do
        Factory.create(:managed_issue)
      end

      (1..2).each do
        Factory.create(:managed_issue, :exclude_from_result => true)
      end

    end

    it "assigns all issues as @issues" do
      get :index
      assigns(:projects).should == Issue.where(:type => 'ManagedIssue').where(:exclude_from_result => false).all
    end

    it "assigns activity items to @recent_items" do
      item = mock_model(Contribution)
      activity = mock_model(Activity)
      Activity.should_receive(:most_recent_activity_items).and_return([item])
      get :index

      assigns(:recent_items).should == [item]
    end

  end

end
