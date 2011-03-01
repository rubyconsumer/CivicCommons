require 'spec_helper'

describe ConversationsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end

  describe "not logged in" do
    before(:each) do
      @controller.stub(:current_person).and_return(nil)
    end

    {:new => :get, :create => :post}.each do |action, *methods|

      methods.each do |method|
        it "redirects to login for #{method} => :#{action}" do
          send(method, action)
          response.should redirect_to new_person_session_url
        end
      end
    end
  end

  describe "GET index" do

    before(:each) do
      @old_conversation = Factory.create(:conversation, {:created_at => (Time.now - 2.days), :updated_at => (Time.now - 30.seconds), :last_visit_date => Time.now, :recent_visits => 2})
      @new_conversation = Factory.create(:conversation, {:created_at => (Time.now - 1.day), :updated_at => (Time.now - 2.seconds), :last_visit_date => Time.now, :recent_visits => 1})
    end

    it "assigns all conversations as @active, @popular, and @recent" do
      get :index
      assigns(:active).first.should == @new_conversation
      assigns(:active).last.should  == @old_conversation
      assigns(:popular).first.should == @old_conversation
      assigns(:popular).last.should == @new_conversation
      assigns(:recent).first.should == @new_conversation
      assigns(:recent).last.should == @old_conversation
    end

  end

  describe "GET show" do
    before(:each) do
      @person = Factory.create(:normal_person)
      @controller.stub(:current_person).and_return(@person)
      Conversation.stub(:includes).with(:issues) { mock_conversation(:issues => :all_issues) }
      Conversation.stub(:find).with("37") { mock_conversation }
    end

    def do_get
      get :show, :id => "37"
    end

    it "assigns the requested conversation as @conversation" do
      do_get
      assigns(:conversation).should be(mock_conversation)
    end
    it "records a visit to the conversation passing the current user" do
      mock_conversation.should_receive(:visit!).with(@person.id)
      do_get
    end
  end

  describe "GET new" do
    before(:each) do
      @controller.stub(:current_person).and_return(Factory.build(:normal_person))
      Conversation.stub(:new) { mock_conversation }
      Issue.stub(:alphabetical) { :all_issues }
      get :new, :accept => true
    end

    it "redirects to responsibilities if :accept is not true" do
      get :new, :accept => nil
      response.should redirect_to(conversation_responsibilities_url)
    end

    it "assigns new conversation as @conversation" do
      assigns(:conversation).should be mock_conversation
    end
  end

  describe "POST create" do
    before(:each) do
      @controller.stub(:current_person) { Factory.build(:normal_person) }
    end

    def do_create
      post :create, :conversation => {}
    end

    describe "with valid params" do
      before(:each) do
        Conversation.stub(:new).with({}) { mock_conversation(:save => true) }
      end

      it "assigns created conversation to @conversation" do
        do_create
        assigns[:conversation].should be mock_conversation
      end

      it "creates conversation with checked issue_ids" do
        Conversation.stub(:new) { mock_conversation(:save => true) }
        Conversation.should_receive(:new).with({'issue_ids' => ["5","10"]})
        post :create, :conversation => {:issue_ids => ["5", "10"]}
      end

      it "redirects to invite page to invite participants" do
        do_create
        response.should redirect_to conversation_invite_url(mock_conversation)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Conversation.stub(:new).with({}) { mock_conversation(:save => false) }
      end

      it "renders :new template" do
        do_create
        response.should render_template(:new)
      end

      it "populates error messages" do
      end
    end
  end

end
