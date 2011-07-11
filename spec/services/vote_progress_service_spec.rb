require 'spec_helper'

describe VoteProgressService do
  def given_valid_votes
    @person1 = Factory.create(:registered_user)
    @person2 = Factory.create(:registered_user)
    @survey = Factory.create(:vote, :max_selected_options => 3)
    @survey_option1 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @survey_option2 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 2)
    @survey_option3 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 3)
    @presenter1 = VoteResponsePresenter.new(:person_id => @person1.id,
      :survey_id => @survey.id, 
      :selected_option_1_id => @survey_option1.id)
    @presenter1.save
    @presenter2 = VoteResponsePresenter.new(:person_id => @person2.id,
      :survey_id => @survey.id, 
      :selected_option_1_id => @survey_option1.id, 
      :selected_option_2_id => @survey_option2.id)
    @presenter2.save
  end
  
  describe "calculate_progress" do
    it "should return 3 results" do
      given_valid_votes
      VoteProgressService.new(@survey).calculate_progress.count.should == 3 
    end
    it "should return the correct attributes" do
      given_valid_votes
      VoteProgressService.new(@survey).calculate_progress.first.attributes.keys.should == 
      ['description', 'survey_id', 'survey_option_id', 'title', 'total_votes', 'weighted_votes']
    end
    it "should return the correct total votes" do
      given_valid_votes
      VoteProgressService.new(@survey).calculate_progress.first.total_votes.to_i.should == 2
    end
    it "should return the correct weighted votes" do
      given_valid_votes
      VoteProgressService.new(@survey).calculate_progress.first.weighted_votes.to_i.should == 6
    end
  end
  
  describe "format_data" do
    it "should correctly format an empty array" do
      VoteProgressService.format_data([]).should == []
    end
    it "should correctly format a 1 length array into a 1 dimensional array" do
      VoteProgressService.format_data([1]).should == [[1]]
    end
    
    it "should correctly format a 2 length array into a 2 dimensional array" do
      VoteProgressService.format_data([1,2]).should == [[1,0],[0,2]]
    end
    
    it "should correctly format a 3 length array into a 3 dimensional array" do
      VoteProgressService.format_data([1,2,3]).should == [[1,0,0],[0,2,0],[0,0,3]]
    end
  end
  
  describe "formatted_weigthed_votes" do
    it "should call the format_data" do
      given_valid_votes
      VoteProgressService.should_receive(:format_data)
      VoteProgressService.new(@survey).formatted_weigthed_votes
    end
  end
  
  describe "render_chart" do
    it "should correctly display the google chart url" do
      given_valid_votes
      VoteProgressService.new(@survey).render_chart.should be_include "http://chart.apis.google.com/chart"
    end
  end
  
end
