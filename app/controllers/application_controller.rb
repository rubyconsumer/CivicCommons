class ApplicationController < ActionController::Base

  protect_from_forgery
  include AvatarHelper

  layout 'application'

protected

  def verify_admin
    unless current_person && current_person.admin?
      flash[:error] = "You must be an admin to view this page."
      redirect_to new_person_session_path
    end
  end

  def require_user
    if current_person.nil?
      # AJAX file uploads submitted normal-style via iframe, so also
      # check for custom remotipart_submitted param set in jquery.remotipart.js
      if request.xhr? || params[:remotipart_submitted]
        @requested_url = request.url
        respond_to do |format|
          format.html { render :partial => 'sessions/new' }
          format.js { render 'sessions/new_in_modal' }
        end
      else
        redirect_to new_person_session_url
      end
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if session[:previous] && session[:previous].match(/register\/new/).nil?
      session[:previous]
    elsif session[:link]
      new_link_path
    else
      super
    end
  end

  def require_ssl
    if not request.ssl? and Civiccommons::Config.security['ssl_login']
      redirect_to request.url.gsub(/http:/i, 'https:')
    end
  end

end
