class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def verify_admin
    if current_person.nil? || !current_person.admin
      flash[:error] = "You must be an admin to view this page."
      redirect_to new_person_session_path
    end
  end    
end
