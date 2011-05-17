require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Admin User Registration Tool", %q{
  As an administrator
  I want to register new users without requiring the email confirmation
  So that I can get more people into our system and active
} do

  before(:each) do
    logged_in_as_admin
    ActionMailer::Base.deliveries.clear
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
    #Given I am on the new person registration page
    visit new_admin_user_registration_path
    #When I fill in the form with valid person information
    fill_in "Name", with: 'Jane Doe'
    fill_in "Email", with: 'jdoe@testaccount.com'
    fill_in "Zip Code", with: '44114'
    fill_in "Password", with: 'abc123'
    #And I click the submit button
    click_button "Save Person"
    #Then I should be on the admin people page
    current_url.should include('/admin/people')
    #And I should see a message thanking the user for registering
    page.should have_content('Thank you for registering with the Civic Commons')
    #And the user should have received the Civic Commons Welcome email
    ActionMailer::Base.deliveries.length.should == 2
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    #Given there is an unconfirmed user
    Factory.create(:normal_person)
    #When I visit the current people page
    visit admin_people_path
    #Then I should see a confirm button for each user
    page.should have_link('Confirm')
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    #Given There is a user named Jose Doe that is not confirmed
    jose = Factory.create(:normal_person, name: 'Jose Doe')
    #And I am on the current people page
    visit admin_people_path
    #When I click on the confirm button for John Doe
    click_link('Confirm')
    #Then I should be on the current people page
    visit admin_people_path
    #And Jose Doe should now be confirmed
    jose.confirmed?
  end

end
