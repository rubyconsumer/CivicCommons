require "spec_helper"

describe TopItemsController do

  describe "routing" do

    it "recognizes and generates #newest" do
      { get: "/top_items/newest" }.should route_to(controller: "top_items", action: "newest")
    end

    it "recognizes and generates #highest_rated" do
      { get: "/top_items/highest_rated" }.should route_to(controller: "top_items", action: "highest_rated")
    end

    it "recognizes and generates #most_visited" do
      { get: "/top_items/most_visited" }.should route_to(controller: "top_items", action: "most_visited")
    end

  end

end
