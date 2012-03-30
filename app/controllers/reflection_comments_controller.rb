class ReflectionCommentsController < ApplicationController
  layout 'opportunity'

  before_filter :require_user, :only => [:create]
  before_filter :find_conversation_and_reflection

  def create
    @comment = @reflection.comments.build(params[:reflection_comment])
    @comment.person_id = current_person.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to conversation_reflection_path @conversation, @reflection }
      else
        format.html { render :template => '/reflections/show' }
      end
    end
  end

  protected
  def find_conversation_and_reflection
    @conversation = Conversation.find(params[:conversation_id])
    @reflection = @conversation.reflections.find(params[:reflection_id])
  end


end
