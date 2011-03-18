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

  end

end
