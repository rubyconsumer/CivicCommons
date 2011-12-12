module CivicCommonsDriver::Pages
  class RegistrationPage
    SHORT_NAME = :registration_page
    LOCATION = '/people/register/new'
    include Page
    has_field :bio, "person_bio"
    has_field :zip_code, "person_zip_code"

    has_link :connect_with_facebook, "facebook-connect", :thanks_go_check_your_email
  end
end
