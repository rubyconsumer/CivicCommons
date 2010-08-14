class PostCommentsController < ApplicationController
  respond_to :html, :xml, :json    
  def new 
    @comment = Comment.new
    render :layout=>false
  end
  
  def create
    @comment = Comment.create_for_conversation(params[:comment], params[:conversation_id], current_person)
    if @comment.errors.blank?
      flash[:notice] = 'Comment was successfully created.'      
    else
      render :json=>@comment.errors.to_json and return
    end    
    respond_to do |format|
      format.html { render :partial=>"conversations/comment", :locals => { :postable => @comment }}
      format.json { render :json=>@comment.to_json}
    end
  end
end
