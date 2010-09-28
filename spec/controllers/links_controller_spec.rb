require 'spec_helper'

describe LinksController do

  def mock_link(stubs={})
    @mock_link ||= mock_model(Link, stubs).as_null_object
  end

  describe "GET new" do 

    describe "not logged in" do

      before(:each) do
        @controller.stub(:current_person).and_return(nil)
        get :new, :link => "http://aol.com"
      end

      it "should redirect to login" do
        response.should redirect_to(new_person_session_url)
      end

      it "should store the user's link" do
        session[:link].should == "http://aol.com"
      end
      
    end

    describe "logged in" do

      before(:each) do
        Issue.stub(:all)        { :all_issues }
        Conversation.stub(:all) { :all_conversations }
        @controller.stub(:current_person).and_return(Person.new)
        get :new, :link => "http://aol.com"
      end

      it "should assign all issues to @issues" do 
        assigns(:issues).should be(:all_issues)
      end

      it "should assign all conversations to @converstations" do 
        assigns(:conversations).should be(:all_conversations)
      end

    end

  end

  describe "POST create" do 

    it "should assign link to story" do 
      @controller.stub(:current_person).and_return(Person.new)
      Link.stub(:new).with({'these' => 'params'}) { mock_link(:save => true) }
      post :create, :link => { 'these' => "params"}
      assigns(:link).should be (mock_link) 
    end

    it "should redirect to the parent resource's path"
  end

end
