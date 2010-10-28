class ApplicationController < ActionController::Base

  protect_from_forgery
  include AvatarHelper
  
  layout 'application'
  
  def verify_admin
    unless current_person && current_person.admin?
      flash[:error] = "You must be an admin to view this page."
      redirect_to new_person_session_path
    end
  end

  def require_user
    redirect_to new_person_session_url if current_person.nil?
  end

  def after_sign_in_path_for(resource_or_scope)
    pa_session = PeopleAggregator::Login.login(current_person.email, current_person.encrypted_password)
    cookies[:pa_auth_token] = pa_session.authToken if pa_session.respond_to?(:authToken)
    
    if session[:link] 
      new_link_path
    else
      super
    end
  end
  
  
  # Override Devise Sign Out Behavior
  # * Delete the pa_auth_token cookie
  # * Redirect to the PA logout page
  def after_sign_out_path_for(resource_or_scope)
    cookies.delete :pa_auth_token
    
    "#{Civiccommons::PeopleAggregator.URL}/logout.php?redirect=http://#{request.host}#{request.port == "80" ? nil : ":#{request.port}"}"
  end
  
end

