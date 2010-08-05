require 'spec_helper'

describe ConversationCommentsController do

  describe "GET 'create'" do
    it "should be successful" do
      mock_comment = mock_model(Comment)
      Comment.stub(:create_for_conversation).and_return(mock_comment)
      mock_comment.stub(:errors).and_return({})      
      get 'create'
      response.should be_success
    end
  end
end
