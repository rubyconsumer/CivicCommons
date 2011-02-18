require "spec_helper"

describe UserController do

  describe "routing" do

    it "recognizes and generates #show" do
      { get: "/user/1" }.should route_to(controller: "user", action: "show", id: "1")
    end

    it "recognizes and generates #update" do
      { put: "/user/1" }.should route_to(controller: "user", action: "update", id: "1")
    end

    it "recognizes and generates #edit" do
      { get: "/user/1/edit" }.should route_to(controller: "user", action: "edit", id: "1")
    end

  end

end
