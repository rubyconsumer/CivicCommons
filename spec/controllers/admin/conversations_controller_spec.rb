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

  end
end
