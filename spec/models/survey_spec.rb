require 'spec_helper'

describe Survey do
  context "Associations" do
    context "has_many :options" do
      it "should have many options" do
        Survey.reflect_on_association(:options).macro.should == :has_many
      end
      
      it "should have the class name as 'SurveyOption" do
        Survey.reflect_on_association(:options).options[:class_name].should == "SurveyOption"
      end
      
      it "should have foreign_key as 'survey_id" do
        Survey.reflect_on_association(:options).options[:foreign_key].should == 'survey_id'        
      end
      
      it "should destroy dependent when it is destroyed" do
        Survey.reflect_on_association(:options).options[:dependent].should == :destroy
      end
    end
    
    context "belongs_to :surveyable" do
      it "should really belongs to surveyable" do
        Survey.reflect_on_association(:surveyable).macro.should == :belongs_to
      end
      
      it "should be polymorphic " do
        Survey.reflect_on_association(:surveyable).options.should == {:polymorphic=>true, :foreign_type=>"surveyable_type"}
      end
    end
    
    context "accepts_nested_attributes_for :options" do
      it "should correctly create nested models" do
        @survey = Factory.build(:survey)
        @survey.options_attributes = [{:title => 'option title here', :description => 'option description here', :nested => true}]
        @survey.save
        @survey.should be_valid
        SurveyOption.count.should == 1
      end
      
    end
    
    context "has_many survey_responses" do
      it "should have many survey_responses" do
        Survey.reflect_on_association(:survey_responses).macro == :has_many
      end
      
      it "should not destroy this object if it has dependencies" do
        Survey.reflect_on_association(:survey_responses).options[:dependent].should == :restrict
      end
    end
    
  end

  context "Validations" do
    before(:each) do
      @survey = Survey.create
    end
    it "should NOT validate presence of surveyable" do
      @survey.errors[:surveyable_id].should be_blank
      @survey.errors[:surveyable_type].should be_blank
    end
    it "should validate presence_of end_date" do
      @survey.errors[:end_date].should == ["can't be blank"]
    end
  end
  
  context "Single Table Inheritance" do
    it "can be a Vote" do
      Vote.superclass.should == Survey
    end
    it "can be a Poll" do
      Poll.superclass.should == Survey
    end
  end
  
  context "End Date" do
    it "should display the survey progress if show_progress is set to true AND end_date is less than today's date" do
      @survey = Factory.create(:survey, :end_date => 2.days.ago.to_date, :show_progress => true)
      @survey.end_date.should be_present
      @survey.show_progress_now?.should == true
    end
    it "should NOT display survey progress if show_progress is set to true AND end_date is later than Today's date" do
      @survey = Factory.create(:survey, :end_date => 2.days.from_now.to_date, :show_progress => true)
      @survey.show_progress_now?.should == false
    end
    it "should NOT display survey progress if show_progress is set to false" do
      @survey = Factory.create(:survey, :end_date => 2.days.from_now.to_date, :show_progress => false)
      @survey.show_progress_now?.should == false
    end
  end
  
  context "active?" do
    it "should be active when there is no start_date" do
      @survey = Factory.create(:survey, :show_progress => true)
      @survey.should be_active
    end
    it "should not be active when the start_date is in the future" do
      @survey = Factory.create(:survey, :show_progress => true, :start_date => 1.days.from_now.to_date)
      @survey.should_not be_active
    end
    it "should be active when the start_date is in the past" do
      @survey = Factory.create(:survey, :show_progress => true, :start_date => 1.days.ago.to_date)
      @survey.should be_active
    end
    it "should be active when the start_date is today" do
      @survey = Factory.create(:survey, :show_progress => true, :start_date => Date.today)
      @survey.should be_active
    end
  end
  context "days_until_end_date" do
    it "should display the number of days until end date if end_date is in the future" do
      @survey = Factory.create(:survey, :end_date => 1.days.from_now.to_date, :show_progress => false)
      @survey.days_until_end_date.should == 1
    end
    it "should display nil if end_date is today" do
      @survey = Factory.create(:survey, :end_date => Date.today, :show_progress => false)
      @survey.days_until_end_date.should be_nil
    end
  end
end
