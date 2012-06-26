module SecureUrlHelper
  include Rails.application.routes.url_helpers
  
  def self.protocol
    if self.https?
      'https'
    else
      'http'
    end
  end

  def self.http?
    not self.https?
  end

  def self.https?
    cc = Civiccommons::Config
    cc.respond_to?('security') and cc.security.key?('ssl_login') and cc.security['ssl_login']
  end

  def secure_registration_form_url
    new_person_registration_url(:protocol => SecureUrlHelper.protocol)
  end

  def secure_registration_url(resource_name)
    if SecureUrlHelper.https?
      registration_url(resource_name).gsub(/http:\/\//, 'https://')
    else
      registration_url(resource_name)
    end
  end

  def secure_edit_user_url(resource_name)
    edit_user_url(resource_name, :protocol => SecureUrlHelper.protocol)
  end

  def secure_user_url(resource_name)
    user_url(resource_name, :protocol => SecureUrlHelper.protocol)
  end

  def secure_session_url(resource_name)
    if SecureUrlHelper.https?
      session_url(resource_name).gsub(/http:\/\//, 'https://')
    else
      session_url(resource_name)
    end
  end

  def secure_new_person_registration_url()
    new_person_registration_url(:protocol => SecureUrlHelper.protocol)
  end

  def secure_new_person_session_url()
    new_person_session_url(:protocol => SecureUrlHelper.protocol)
  end

end
