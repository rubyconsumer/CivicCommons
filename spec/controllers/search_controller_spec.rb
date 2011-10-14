require 'spec_helper'

describe SearchController do
  describe "GET results" do
    it "will render expected template" do
      get :results, :q => ''
      response.should render_template('search/results')
    end

    it "will set flash[:error] for an empty search query request and return no search results" do
      get :results, :q => ''
      should assign_to(:results).with([])
      should set_the_flash.to("You did not search for anything.  Please try again.")
    end
  end
end