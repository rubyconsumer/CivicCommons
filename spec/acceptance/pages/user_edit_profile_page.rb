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
      has_field(:zip_code, "Zip code")

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
      def url
        @url
      end
    end
  end
end
