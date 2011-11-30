require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!

Capybara.default_wait_time = 20


feature "User Settings", %q{
  In order to display relevant info about the user
  As a current user
  I want to be able to manage my user profile
} do

  scenario "Zipcode validation message on user profile if user had not previously added the zipcode" do
    login_as :person_without_zip_code
    goto :edit_profile_page, :for=>logged_in_user
    current_page.should contain 'please enter zipcode, must be 5 characters or higher'
  end
  scenario "Zip Code required on user update on profile page" do
    login_as :person_without_zip_code
    update_zip_code_to ""
    current_page.should contain 'please enter zipcode, must be 5 characters or higher'
  end

  scenario "Unsubscribe from weekly newsletter" do
    login_as :person_subscribed_to_weekly_newsletter
    remove_subscription_to :weekly_newsletter
    database.find_user(logged_in_user).should_not be_subscribed_to :weekly_newsletter
  end

  scenario "unsubscribe from daily digest" do
    login_as :person_subscribed_to_daily_digest
    remove_subscription_to :daily_digest
    database.find_user(logged_in_user).should_not be_subscribed_to :daily_digest
  end
  def update_zip_code_to code
    goto :edit_profile_page, :for=>logged_in_user
    fill_in_zip_code_with code
    submit
  end
  def remove_subscription_to mailing
    goto :edit_profile_page, :for=>logged_in_user
    unsubscribe mailing
    submit
  end
end
