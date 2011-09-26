require File.dirname(__FILE__) + '/../spec_helper'

describe HomepageController do
  describe "GET 'show'" do
    it "should retrieve the top visited conversations" do
      mock_convo = mock_model(Conversation)
      mock_convo.should_receive(:to_ary)
      mock_conversations = [mock_convo]
      Conversation.stub(:get_top_visited).and_return(mock_conversations)
      get :show
      assigns(:most_visited_conversations).should eq(mock_conversations)
    end
  end
end
