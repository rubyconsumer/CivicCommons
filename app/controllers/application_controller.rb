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
    
    @postable = @conversable.create_post(@postable, current_person)
    
    respond_to do |format|
      format.html { render :partial=>"/"+find_conversable.class.to_s.pluralize+"/"+params[:post_model_type].downcase, :locals => { :postable => @postable }}      
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
