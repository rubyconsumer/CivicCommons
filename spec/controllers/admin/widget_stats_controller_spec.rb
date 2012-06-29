require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::WidgetStatsController do
  
  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
  end

  def mock_widget_log(stubs={})
    @mock_widget_log ||= mock_model(WidgetLog, stubs).as_null_object
  end

  describe "GET index" do
    before(:each) do
      WidgetLog.stub!(:find_all_url_summary_for_week).and_return([mock_widget_log])
    end
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should assign the @week_of variable" do
      get :index, :week_of => '123'
      assigns(:week_of).should == '123'
    end
    it "should assign the @widget_stats variable" do
      WidgetLog.should_receive(:find_all_url_summary_for_week).with('123').and_return([mock_widget_log])
      get :index, :week_of => '123'
      assigns(:widget_stats).should == [mock_widget_log]
    end
  end

  describe "GET show" do
    before(:each) do
      WidgetLog.stub!(:find_one_url_summary_for_week).and_return([mock_widget_log])
    end
    it "assigns @widget_url" do
      get :show, widget_url: '/path/to/widget/here'
      assigns(:widget_url).should == '/path/to/widget/here'
    end
    it "assigns @week_of" do
      get :show, widget_url: '/path/to/widget/here', week_of: '123'
      assigns(:week_of).should == '123'
    end
    it "assigns @widget_stats" do
      WidgetLog.should_receive(:find_one_url_summary_for_week).with('/path/to/widget/here', '123').and_return([mock_widget_log])
      get :show, widget_url: '/path/to/widget/here', week_of: '123'
    end
    it "should be success" do
      get :show, widget_url: '/path/to/widget/here'
      response.should be_success
    end
  end


end
