class SessionsController < Devise::SessionsController

  def new
    session[:previous] = request.headers["Referer"]
    clean_up_passwords(build_resource)
    render_with_scope :new
  end

  def create
    super
    session[:previous] = nil
  end


# POST /resource/ajax_login
  def ajax_create
    resource = warden.authenticate!(:scope => resource_name, :recall => "new")
    sign_in(resource_name, resource)
    render :action => :new
  end

end
