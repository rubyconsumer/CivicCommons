module CivicCommonsDriver

  module Pages
    class EditUserProfilePage
      SHORT_NAME = :edit_profile_page
      include Page

      has_checkbox(:weekly_newsletter, "person[weekly_newsletter]")
      has_checkbox(:daily_digest, "person[daily_digest]")
      has_button(:update_settings, "Update Settings", :home)
      has_link(:connect_to_facebook, "facebook-connect")
      has_link(:yes_use_conflicting_email, "Yes, thanks")
      has_link(:unlink_from_facebook, "facebook-connect")
      has_link(:confirm_unlink_from_facebook, "confirm-facebook-unlinking")
      has_field(:email, 'person_email')
      has_field(:password, "person_password")
      has_field(:confirm_password, "person_password_confirmation")
      has_field(:zip_code, "Zip code")
      has_button(:submit, "person_submit")
      has_button(:submit_invalid_form, "person_submit")

      def initialize(options)
        @url = "/user/#{options[:for].friendly_id}/edit"
      end
      def submit
        click_update_settings_button
      end
      def unsubscribe mailing
        send("uncheck_#{mailing}")
      end
      def use_facebook_email
        wait_until { yes_use_conflicting_email_link.visible? }
        follow_yes_use_conflicting_email_link
      end
      def has_password_required_error?
        has_css? '.field-with-error input#person_password'
      end
      def url
        @url
      end
    end
  end
end
