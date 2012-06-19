require File.dirname(__FILE__) + '/../spec_helper'

describe HomepageController do
  describe "GET 'show'" do
    it "should retrieve the most active, visited and latest conversations" do
      mock_convo = mock_model(Conversation)

      mock_conversations = [mock_convo]
      mock_conversations.should_receive(:limit).with(1).exactly(2).times

      Conversation.stub(:latest_created ).and_return(mock_conversations)
      Conversation.stub(:most_active    ).and_return(mock_conversations)
      Conversation.stub(:get_top_visited).and_return(mock_conversations)

      get :show
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
