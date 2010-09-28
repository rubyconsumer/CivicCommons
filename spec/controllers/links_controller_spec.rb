require 'spec_helper'

describe LinksController do

  describe "GET new" do 

    describe "not logged in" do

      before(:each) do
        @controller.stub(:current_person).and_return(nil)
        get :new, :link => "http://aol.com"
      end

      it "should redirect to login" do
        response.should redirect_to(new_person_session_url)
      end

      it "should set flash message" 
      it "should store the user's link"  
      it "should store the url"
    end

    describe "logged in" do
      it "should assign to @contributions"
      it "should assign to @issues"
    end

  end

  describe "POST create" do 
    it "should assign link to story"
  end

end
