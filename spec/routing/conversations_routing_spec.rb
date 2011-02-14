require "spec_helper"

describe ConversationsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/conversations" }.should route_to(:controller => "conversations", :action => "index")
    end

    it "recognizes and generates #new" do
      pending "BUG IN RAILS PREVENTS THIS FROM PASSING, BUG ONLY AFFECTS TESTS, NOT ACTUAL APP...
      Should be re-enabled when bug is fixed. Bug described:
      https://github.com/rspec/rspec-rails/issues/issue/239
      https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/5805"
      { :get => "/conversations/new" }.should route_to(:controller => "conversations", :action => "new")
    end

    it "recognizes and generates #show" do
      pending "SEE PREVIOUS PENDING MESSAGE FOR `generates #new`."
      { :get => "/conversations/1" }.should route_to(:controller => "conversations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/conversations/1/edit" }.should route_to(:controller => "conversations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/conversations" }.should route_to(:controller => "conversations", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/conversations/1" }.should route_to(:controller => "conversations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/conversations/1" }.should route_to(:controller => "conversations", :action => "destroy", :id => "1") 
    end

    Conversation.available_filter_names.each do |filter_name|
      it "recognizes and generates #filter route for :#{filter_name} filter" do
        { :get => "/conversations/#{filter_name}" }.should route_to(:controller => "conversations", :action => "filter", :filter => filter_name)
      end
    end

  end
end
