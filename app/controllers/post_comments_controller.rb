class PostCommentsController < ApplicationController
  respond_to :html, :xml, :json    
  def new 
    @conversable = find_conversable
    @comment = Comment.new(params[:comment])
    render :layout=>false
  end
  
  def create
    @conversable = find_conversable
    @conversable.create_post_comment(params[:comment], current_person)
    #@comment = Comment.create_for_conversation(params[:comment], params[:conversation_id], current_person)
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
  
  private
  
  def find_conversable
    params.each do |name, value|  
      if name =~ /(.+)_id$/  
        return $1.classify.constantize.find(value)  
      end  
    end  
    nil  
  end  
  
end
