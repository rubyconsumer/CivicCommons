class ApplicationController < ActionController::Base

  protect_from_forgery
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

end   

