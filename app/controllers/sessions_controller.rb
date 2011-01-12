class SessionsController < Devise::SessionsController
# POST /resource/ajax_login
  def ajax_create
    resource = warden.authenticate!(:scope => resource_name, :recall => "new")
    sign_in(resource_name, resource)
    render :action => :new
  end
  
end
