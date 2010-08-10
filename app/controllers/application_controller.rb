class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def verify_admin
    flash[:error] = "You must be an admin to view this page."
    redirect_to new_person_session_path unless (!current_person.nil? && person_signed_in? && current_person.admin)
  end    
end
