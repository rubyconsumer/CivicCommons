require "spec_helper"

describe WidgetController do

  describe "routing" do

    it "recognizes and generates #index" do
      { get: "/widget" }.should route_to(controller: "widget", action: "index")
    end

  end

end
