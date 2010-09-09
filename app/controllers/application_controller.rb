class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def verify_admin
    unless current_person && current_person.admin?
      flash[:error] = "You must be an admin to view this page."
      redirect_to person_session_new_path
    end
  end
end   

