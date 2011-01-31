require 'spec_helper'

describe ConversationsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end

  describe "GET index" do

    before do
      @old_conversation = Factory.create(:conversation, {:updated_at => (Time.now - 30.seconds)})
      @new_conversation = Factory.create(:conversation, {:updated_at => (Time.now - 2.seconds)})
    end

    it "assigns all conversations as @conversations" do
      get :index
      assigns(:conversations).first.should == @new_conversation
      assigns(:conversations).last.should  == @old_conversation
    end

  end

  describe "GET show" do
    before(:each) do
      @person = Factory.create(:normal_person)
      @controller.stub(:current_person).and_return(@person)
    end
    it "assigns the requested conversation as @conversation" do
      pending
      Conversation.stub(:find).with("37") { mock_conversation }
      get :show, :id => "37"
      assigns(:conversation).should be(mock_conversation)
    end
    it "records a visit to the conversation passing the current user" do
      pending
      Conversation.stub(:find).with("37") { mock_conversation }
      mock_conversation.should_receive(:visit!).with(@person.id)
      get :show, :id => "37"
    end
  end

end
