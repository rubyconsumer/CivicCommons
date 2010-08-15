require 'spec_helper'

describe PostRatingsController do
  describe "GET 'create'" do
    before(:each) do 
      @controller.stub(:current_person).and_return(@mock_person)      
    end
    it "should be successful" do
      mock_rating = mock_model(Rating)
      mock_conversation = mock_model(Conversation, {:rating=>5})      
      
      Rating.stub(:create_for_conversation).and_return(mock_rating)
      Conversation.stub(:find).and_return(mock_conversation)
      
      mock_rating.stub(:errors).and_return({})      
      get 'create'
      response.should be_success
      response.body.should == "5"
    end
  end
end
