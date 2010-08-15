require 'spec_helper'

describe PostQuestionsController do
  describe "GET 'create'" do
    before(:each) do 
      @controller.stub(:current_person).and_return(@mock_person)      
    end
    it "should be successful" do
      mock_question = mock_model(Question)
      mock_question.stub(:owner=)
      Question.stub(:create_for_conversation).and_return(mock_question)
      mock_question.stub(:errors).and_return({})      
      get 'create'
      response.should be_success
    end
  end
end
