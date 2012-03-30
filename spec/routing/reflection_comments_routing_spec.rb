require "spec_helper"

describe ReflectionCommentsController do
  describe "routing" do

    it "recognizes and generates #create" do
      { :post => "/conversations/1/reflections/123/comments" }.should route_to(:controller => "reflection_comments", :conversation_id => '1', :reflection_id => '123', :action => "create")
    end

  end
end
