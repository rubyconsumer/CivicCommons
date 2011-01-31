require "spec_helper"

describe ConversationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { get: "/conversations" }.should route_to(controller: "conversations", action: "index")
    end

    it "recognizes and generates #show" do
      { get: "/conversations/1" }.should route_to(controller: "conversations", action: "show", id: "1")
    end

    it "recognizes and generates #node_conversation" do
      { get: "/conversations/node_conversation" }.should route_to(controller: "conversations", action: "node_conversation")
    end

    it "recognizes and generates #node_permalink" do
      { get: "/conversations/node_permalink/1" }.should route_to(controller: "conversations", action: "node_permalink", id: "1")
    end

    it "recognizes and generates #edit_node_contribution" do
      { get: "/conversations/edit_node_contribution" }.should route_to(controller: "conversations", action: "edit_node_contribution")
    end

    it "recognizes and generates #update_node_contribution" do
      { put: "/conversations/update_node_contribution" }.should route_to(controller: "conversations", action: "update_node_contribution")
    end

    it "recognizes and generates #new_node_contribution" do
      { get: "/conversations/new_node_contribution" }.should route_to(controller: "conversations", action: "new_node_contribution")
    end

    it "recognizes and generates #preview_node_contribution" do
      { get: "/conversations/preview_node_contribution" }.should route_to(controller: "conversations", action: "preview_node_contribution")
    end

    it "recognizes and generates #confirm_node_contribution" do
      { put: "/conversations/confirm_node_contribution" }.should route_to(controller: "conversations", action: "confirm_node_contribution")
    end

  end
end
