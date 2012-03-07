require "spec_helper"

describe PetitionsController do
  describe "routing" do
    it "recognizes and generates #new" do
      { get: "/conversations/123/petitions/new" }.should route_to(controller: "petitions", action: "new", :conversation_id => '123')
    end

    it "recognizes and generates #create" do
      { post: "/conversations/123/petitions" }.should route_to(controller: "petitions", action: "create", :conversation_id => '123')
    end

    it "recognizes and generates #show" do
      { get: "/conversations/123/petitions/1234" }.should route_to(controller: "petitions", action: "show", :conversation_id => '123', :id => '1234')
    end
    
  end

end
