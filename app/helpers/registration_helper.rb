module RegistrationHelper

  def secure_registration_form_url
    protocol = Civiccommons::Config.security['ssl_login'] ? 'https' : 'http'
    new_person_registration_url(:protocol => protocol)
  end

  def secure_registration_url(resource_name)
    if Civiccommons::Config.security['ssl_login']
      registration_url(resource_name).gsub(/http:\/\//, 'https://')
    else
      registration_url(resource_name)
    end
  end

  def secure_edit_user_url(resource_name)
    protocol = Civiccommons::Config.security['ssl_login'] ? 'https' : 'http'
    edit_user_url(resource_name, :protocol => protocol)
  end

  def secure_user_url(resource_name)
    protocol = Civiccommons::Config.security['ssl_login'] ? 'https' : 'http'
    user_url(resource_name, :protocol => protocol)
  end

  def secure_session_url(resource_name = nil)
    protocol = Civiccommons::Config.security['ssl_login'] ? 'https' : 'http'
    new_person_session_url(resource_name, :protocol => protocol)
  end

  def secure_ajax_login_url
    protocol = Civiccommons::Config.security['ssl_login'] ? 'https' : 'http'
    people_ajax_login_url(:protocol => protocol)
  end

end
