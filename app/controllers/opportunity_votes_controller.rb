class OpportunityVotesController < ApplicationController
  layout 'opportunity'
  before_filter :require_user
  before_filter :find_conversation
  DEFAULT_NUM_OF_OPTIONS = 1
  
  def new
    @vote = Vote.new(:max_selected_options => 1)
    DEFAULT_NUM_OF_OPTIONS.times do |i|
      @vote.options.build(:position => i+1)
    end
  end
  
  def create
    @vote = Vote.new(params[:vote])
    @vote.surveyable = @conversation
    @vote.person = current_person
    
    if @vote.save
      redirect_to(conversation_vote_path(@conversation, @vote), :notice => 'Vote was successfully created.')
    else
      render :action => "new"
    end
    
  end
  
  def show
    @vote = @conversation.surveys.find(params[:id])
    @vote_response_presenter = VoteResponsePresenter.new(:person_id => current_person.id, :survey_id => @vote.id)
    
  end
  
  protected
  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
