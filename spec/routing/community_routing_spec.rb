require "spec_helper"

describe CommunityController do

  describe "routing" do
    it "recognizes and generates #index" do
      { get: "/community" }.should route_to(controller: "community", action: "index")
    end
  end

end
