require "spec_helper"

describe PollsController do

  describe "routing" do
    it "recognizes and generates #index" do
      { get: "/polls" }.should route_to(controller: "polls", action: "index")
    end

    it "recognizes and generates #create" do
      { post: "/polls" }.should route_to(controller: "polls", action: "create")
    end
  end

end
