class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def verify_admin
    if current_person.nil? || !current_person.admin
      flash[:error] = "You must be an admin to view this page."
      redirect_to new_person_session_path
    end
  end    
  
  # POST /<CONTROLLERNAME>/create_post
  def create_post
    @conversable = find_conversable
    
    model_name = params[:post_model_type].downcase.to_sym
    @postable = params[:post_model_type].constantize.new(params[model_name])
    
    logger.info "posting onto a conversable " + @conversable.inspect
    @postable = @conversable.create_post(@postable, current_person)
    
    respond_to do |format|
      # MWS is leaving this line in case it's right...
      # format.html { render :partial=>"/"+find_conversable.class.to_s.pluralize.downcase+"/"+params[:post_model_type].downcase, :locals => { :postable => @postable }}      
      # Theory here is that all the partials we need are part of the
      # Conversations view directory. Even a nested comment attached
      # to a comment is still basically JUST A COMMENT here. So no
      # need to render /comments/comment... it's always
      # /conversation/comment or /conversation/question or the like.
      format.html { render :partial=>"/conversations/"+params[:post_model_type].downcase, :locals => { :postable => @postable }}      
    end
  end  
  
  private    
    def find_conversable
      params.each do |name, value|  
        return $1.classify.constantize.find(value) if name =~ /(.+)_id$/  
      end  
      nil  
    end
end
