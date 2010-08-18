require 'spec_helper'

describe TopItemsController do
  describe "GET 'newest'" do
    before(:each) do
      @mock_top_items = [mock(TopItem)]
      TopItem.stub(:newest_items).and_return(@mock_top_items)
    end
    it "should assign the top items" do      
      get :newest
      assigns(:top_items).should == @mock_top_items
    end
    
    it "should be successful" do
      get :newest
      response.should be_success
    end
  end
end
