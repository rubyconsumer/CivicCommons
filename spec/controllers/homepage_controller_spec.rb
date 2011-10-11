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

    it "will respond to :html format" do
      get :show, format: :html
      response.should be_success
    end

    it "will respond with 406 Not Acceptable to other formats" do
      expect do
        get :show, format: :text
        response.should_not be_success
      end.to_not raise_error(ActionView::MissingTemplate)
    end
  end
end
