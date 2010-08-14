require 'spec_helper'

describe PostCommentsController do
  describe "GET 'create'" do
    before(:each) do 
      @controller.stub(:current_person).and_return(@mock_person)      
    end
    it "should be successful" do
      mock_comment = mock_model(Comment)
      mock_comment.stub(:owner=)
      Comment.stub(:create_for_conversation).and_return(mock_comment)
      mock_comment.stub(:errors).and_return({})      
      get 'create'
      response.should be_success
    end
  end
end
