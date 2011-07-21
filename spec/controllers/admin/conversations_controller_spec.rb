require 'spec_helper'

module Admin
  describe ConversationsController do

    before :each do
      @admin_person = Factory.create(:admin_person)
      @controller.stub(:current_person).and_return(@admin_person)
    end

    describe "ConversationsController#index" do

      it "Assigns @conversations as a collection of Conversation objects" do
        conversation = mock_model(Conversation)
        Conversation.should_receive(:all).and_return([conversation])

        get :index
        assigns(:conversations).should == [conversation]
      end

    end

    describe "ConversationsController#create" do

      it "sets community_generated to false" do
        params = Factory.attributes_for(:conversation)
        params[:owner] = Factory.create(:admin_person)
        params[:issues] = [ Factory.create(:issue) ]
        post :create, conversation: params
        assigns(:conversation).from_community.should be_false
      end

    end

    describe "ConversationsController#new" do

      it "Assigns @conversation as a new instance of Conversation" do
        conversation = mock_model(Conversation)
        Conversation.should_receive(:new).and_return(conversation)

        get :new
        assigns(:conversation).should == conversation
      end

      it "Assigns @present as a new instance of IngestPresenter" do
        presenter = mock(IngestPresenter)
        IngestPresenter.should_receive(:new).and_return(presenter)

        get :new
        assigns(:presenter).should == presenter
      end

    end

    describe "ConversationsController#toggle_staff_pick" do
      it "toggles the staff_pick flag on a given conversation" do
        conversation = Factory.create(:conversation, staff_pick: true)

        put :toggle_staff_pick, id: conversation.id
        Conversation.find_by_id(conversation.id).staff_pick.should be_false
      end

      it "redirects to the original controller action if provided" do
        conversation = Factory.create(:conversation, staff_pick: true)
        Conversation.stub(:find) { conversation }
        conversation.stub(:save) { true }

        post :toggle_staff_pick, id: conversation, redirect_to: 'index'
        response.should redirect_to admin_conversations_path
      end

      it "shows a flash[:error] message if the conversation cannot be saved" do
        conversation = Factory.create(:conversation, staff_pick: true)
        Conversation.stub(:find) { conversation }
        conversation.stub(:save) { false }

        post :toggle_staff_pick, id: conversation
        flash[:error].should_not be_nil
        flash[:error].should include("Error saving")
      end

    end

  end

end
