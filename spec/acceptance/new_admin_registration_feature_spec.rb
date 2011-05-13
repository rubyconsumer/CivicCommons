require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Admin User Registration Tool", %q{
  As an administrator
  I want to register new users without requiring the email confirmation
  So that I can get more people into our system and active
} do

  before(:each) do
    logged_in_as_admin
  end

  scenario "admin wants to register a user manually" do
    #Given I am on the admin home page
    visit admin_root_path
    #When I click the new registration link
    click_link "Register User"
    #Then I should be on the new person registration page
    page.should have_content('New User Registration')
  end

  scenario "admin registers a new user manually" do
    pending
    #Given I am on the new person registration page
    #When I fill in the form with valid person information
    #And I click the submit button
    #Then I should be on the admin people page
    #And I should see a message saying the user was successfully created
    #And the user should have received the Civic Commons Welcome email
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    pending
    #When I visit the current people page
    #Then I should see a confirm button for each user
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    pending
    #Given I am on the current people page
    #And There is a user named John Doe that is not confirmed
    #When I click on the confirm button for John Doe
    #Then I should be on the current people page
    #And John Doe should now be confirmed
  end

end
