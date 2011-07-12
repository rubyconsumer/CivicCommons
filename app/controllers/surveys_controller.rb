class SurveysController < ApplicationController
  before_filter :require_user
  before_filter :find_survey, :only => [:show, :create_response]
  
  def show
    @survey_response_presenter = VoteResponsePresenter.new(:person_id => current_person.id, :survey_id => @survey.id)
    if @survey_response_presenter.already_voted?
      if @survey.show_progress?
        @vote_progress_service = VoteProgressService.new(@survey)
        render :template =>"surveys/show_#{@survey.class.name.underscore}_show_progress"
      else
        render :template => "surveys/show_#{@survey.class.name.underscore}_hide_progress"
      end
    else
      render :template => "surveys/show_#{@survey.class.name.underscore}"
    end
  end
  
  def create_response
    @survey_response_presenter = VoteResponsePresenter.new({:person_id => current_person.id, :survey_id => @survey.id}.merge!(params[:survey_response_presenter]))
    
    # if it has been confirmed, then it can be saved
    if @survey_response_presenter.confirmed?
      if @survey_response_presenter.save
        redirect_to :action => :show
        flash[:vote_successful] = true
      else
        render :template => "surveys/show_#{@survey.class.name.underscore}"
      end
    else
      respond_to do |format|
        format.js{ render :js => render_to_string(:partial => "/surveys/#{@survey.class.name.underscore}_response_confirmation") }
        format.html{render :text => 'Javascript needs to be turned on to vote'}
      end
    end
  end
  
  # vote_successful modal dialog
  def vote_successful
    render :layout => nil
  end
  
protected

  def find_survey
      @survey = Survey.find(params[:id])
  end
  
end