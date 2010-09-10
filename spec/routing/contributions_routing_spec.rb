require "spec_helper"

describe ContributionsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/contributions" }.should route_to(:controller => "contributions", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/contributions/new" }.should route_to(:controller => "contributions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/contributions/1" }.should route_to(:controller => "contributions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/contributions/1/edit" }.should route_to(:controller => "contributions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/contributions" }.should route_to(:controller => "contributions", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/contributions/1" }.should route_to(:controller => "contributions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/contributions/1" }.should route_to(:controller => "contributions", :action => "destroy", :id => "1") 
    end

  end
end
