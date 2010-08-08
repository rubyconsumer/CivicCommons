class PostCommentsController < ApplicationController
  respond_to :html, :xml, :json    
  def new 
    @comment = Comment.new
    render :layout=>false
  end
  
  def create
    @comment = Comment.create_for_conversation(params[:comment], params[:conversation_id])
    if @comment.errors.blank?
      flash[:notice] = 'Comment was successfully created.'      
    end
    respond_with(@comment)          
  end
end
