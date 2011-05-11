class SessionsController < Devise::SessionsController

  before_filter :require_ssl, :only => [:new, :create]

  def new
    super
    if RedirectHelper.valid?(request.headers['Referer'])
      session[:previous] = request.headers['Referer']
    end
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
