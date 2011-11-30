class SettingsPage < PageObject
  def click_unlink_from_facebook
    @page.click_link_or_button "Unlink from Facebook"
  end

  def visit(user)
    @page.visit edit_user_path(user)
  end
end
module CivicCommonsDriver
  module Pages
    class EditUserProfilePage
      SHORT_NAME = :edit_profile_page
      include Page

      has_checkbox(:weekly_newsletter, "person[weekly_newsletter]")
      has_checkbox(:daily_digest, "person[daily_digest]")
      has_button(:update_settings, "Update Settings", :home)
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
      def url
        @url
      end
    end
  end
end
