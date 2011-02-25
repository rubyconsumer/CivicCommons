require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Authorization Threats", %q{
  As an attacker
  I want to circumvent authorization rules
  So I can access protected parts of the site
} do

  describe "when not logged in" do

    # Given an admin user exists
    let :admin do
      Factory :admin_person
    end

    background do
      # Given I am not logged in
      LoginPage.new(page).sign_out
    end

    scenario "I cannot access a user profile page" do
      # When I visit a user's profile page
      # The I should not be on that user's profile page
      # And I should be redirected to the community page
      visit edit_user_path(admin)
      should_not_be_on edit_user_path(admin)
      should_be_on community_path
    end

    scenario "I cannot access the admin pages" do
      # When I visit the admin page
      # Then I should not be on the admin page
      # And I should be redirected to the login page
      visit admin_root_path
      should_not_be_on admin_root_path
      should_be_on new_person_session_path
    end

  end

  describe "when logged in" do

    # Given an admin user exists
    let :admin do
      Factory :admin_person
    end

    # Given a registered user (non-admin) exists
    let :user do
      Factory :registered_user
    end

    background do
      # Given I am logged in as a registered user
      LoginPage.new(page).sign_in(user)
    end

    scenario "I cannot access a user profile page" do
      # When I visit a user's profile page
      # The I should not be on that user's profile page
      # And I should be redirected to the community page
      visit edit_user_path(admin)
      should_not_be_on edit_user_path(admin)
      should_be_on community_path
    end

    scenario "I cannot access the admin pages" do
      # When I visit the admin page
      # Then I should not be on the admin page
      # And I should be redirected to home page
      visit admin_root_path
      should_not_be_on admin_root_path
      should_be_on root_path
    end

  end

end
