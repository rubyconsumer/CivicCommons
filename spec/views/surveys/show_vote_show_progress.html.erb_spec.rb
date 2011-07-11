require 'spec_helper'
describe '/surveys/show_vote_show_progress.html.erb' do
    
  def content_for(name) 
    view.instance_variable_get(:@_content_for)[name] 
  end
  
  
  def given_a_vote_response_presenter_that_is_persisted
    @surveyable = stub_model(Issue)
    @survey = stub_model(Vote, :surveyable => @surveyable)
    @survey_options = [stub_model(SurveyOption)]
    @person = stub_model(Person)
    @survey_response_presenter = stub("VoteResponsePresenter", 
      :available_options => @survey_options, 
      :survey => @survey, 
      :survey_response => @survey_response,
      :already_voted? => true,
      :max_selected_options => 3).as_null_object
      
    view.stub(:current_person).and_return(@person)
    
    @vote_progress_service = stub('VoteProgressService')
  end
  


    
  it "should render the progress" do
    given_a_vote_response_presenter_that_is_persisted
    @vote_progress_service.should_receive(:render_chart)
    render
    content_for(:main_body).should render_template("issues/_survey_header")
  end
  
  
end
