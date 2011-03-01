require 'spec_helper'

describe ConversationsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
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
