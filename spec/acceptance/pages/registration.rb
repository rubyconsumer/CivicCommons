module CivicCommonsDriver
  class RegistrationPage
    SHORT_NAME = :registration_page
    LOCATION = '/people/register/new'
    include Page
    has_field :bio, "person_bio"
    has_field :zip_code, "person_zip_code"
    has_field :first_name,  'person_first_name'
    has_field :last_name, 'person_last_name'
    has_field :email, 'person_email'
    has_field :password, 'person_password'
    has_field :password_confirmation, 'person_password_confirmation'
    has_file_field :avatar, 'person_avatar'
    has_button :continue, 'Continue', :home
    has_button :continue_with_invalid_information, 'Continue', :registration_page

    has_checkbox :weekly_newsletter, 'person_weekly_newsletter'
    has_checkbox :daily_digest, 'person_daily_digest'

    has_link :connect_with_facebook, "facebook-connect", :home
    has_link :failing_connect_with_facebook, "facebook-connect"
    has_link :i_dont_want_to_use_facebook, "I don't have a Facebook account", :registration_page

    def has_an_error_for? field
      case field
      when :invalid_name
        error_msg = "Name can't be blank"
      when :invalid_email
        error_msg = "Email can't be blank"
      when :invalid_password
        error_msg = "Password can't be blank"
      when :invalid_zip
        error_msg = "please enter zipcode"
      end
      has_content? error_msg
    end
    def conflicting_email_modal
      ConflictingEmailModal.new
    end
    class ConflictingEmailModal
      SHORT_NAME = :conflicting_email_modal
      include Page
      def has_become_visible?
        wait_until { has_css? ".registering-email-taken" }
        true
      end
    end
  end
end
