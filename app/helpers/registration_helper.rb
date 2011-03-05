module RegistrationHelper

  def secure_registration_url(resource_name)
    registration_url(resource_name).gsub(/http:\/\//, 'https://')
  end

end
