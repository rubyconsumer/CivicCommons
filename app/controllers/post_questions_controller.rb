class PostQuestionsController < ApplicationController
  respond_to :html, :xml, :json    
  def new 
    @question = Question.new
    render :layout=>false
  end
  
  def create
    @question = Question.create_for_conversation(params[:question], params[:conversation_id], current_person)
    if @question.errors.blank?
      flash[:notice] = 'Question was successfully created.'      
    else
      render :json=>@question.errors.to_json and return
    end    
    respond_to do |format|
      format.html { render :partial=>"conversations/question", :locals => { :postable => @question }}
      format.json { render :json=>@question.to_json}
    end
  end
end
