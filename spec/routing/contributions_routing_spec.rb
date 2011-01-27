require "spec_helper"

describe ContributionsController do
  describe "routing" do

    it "recognizes and generates #create_from_pa" do
      { get: "/contributions/create_from_pa"}.should route_to(controller: 'contributions', action: 'create_from_pa')
    end

    it "recognizes and generates #update" do
      { put: "/contributions/1" }.should route_to(controller: "contributions", action: "update", id: "1") 
    end

    it "recognizes and generates #destroy" do
      { delete: "/contributions/1" }.should route_to(controller: "contributions", action: "destroy", id: "1") 
    end

  end
end
