class SessionsController < Devise::SessionsController

  before_filter :require_ssl, :only => [:new, :create]

  def new
    super

    # only set the previous page url if it is not a devise route
    match = false
    Devise.mappings.each_key do |mapping|
      scoped_path = Devise.mappings[mapping].scoped_path
      Devise.mappings[mapping].path_names.each_pair do |path_key, path_name|
        path = scoped_path + '/' + path_name
        if !request.headers['Referer'].nil? && request.headers['Referer'].match("#{path}")
          match = true 
        end
      end
    end
    session[:previous] = request.headers['Referer'] unless match
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
