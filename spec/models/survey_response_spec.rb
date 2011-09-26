require 'spec_helper'

describe SurveyResponse do
  context "Associations" do
    it "should has many selected_survey_options" do
      SurveyResponse.reflect_on_association(:selected_survey_options).macro.should == :has_many
    end
    
    it "should destroy selected_survey_options dependents" do
      SurveyResponse.reflect_on_association(:selected_survey_options).options[:dependent].should == :destroy
    end
    
    it "should belong to person" do
      SurveyResponse.reflect_on_association(:person).macro.should == :belongs_to
    end
    
    it "should belong_to survey" do
      SurveyResponse.reflect_on_association(:survey).macro.should == :belongs_to
    end
  end

  context "Validations" do
    before(:each) do
      @survey_response = SurveyResponse.create
    end
    it "should validate presence of person_id" do
      @survey_response.errors[:person_id].should == ["can't be blank"]
    end
  end
  
  context "scope" do
    context "sort_last_created_first" do
      def given_survey_responses
        @survey_response1 = Factory.create(:survey_response, :created_at => Date.today)
        @survey_response2 = Factory.create(:survey_response, :created_at => 1.days.ago)
      end
      it "should sort by last created at" do
        given_survey_responses
        SurveyResponse.sort_last_created_first.all.should == [@survey_response1,@survey_response2]
      end
    end
  end

end