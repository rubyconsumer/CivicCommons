require 'spec_helper'

describe Admin::RegionsController do 

  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
  end

  describe "GET new" do
    it "should assign to region" do
      Region.stub(:new).and_return(:region)
      get :new
      assigns(:region).should == :region
    end
  end
  
end
