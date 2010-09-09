require 'spec_helper'

describe Admin::DashboardController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

end
