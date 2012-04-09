require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Admin User Registration Tool", %q{
  As an administrator
  I want to register new users without requiring the email confirmation
  So that I can get more people into our system and active
} do

  before(:each) do
    login_as :admin
    ActionMailer::Base.deliveries.clear
  end

  scenario "admin wants to register a user manually" do
    visit admin_root_path
    click_link "Register User"
    page.should have_content('New User Registration')
  end

  scenario "admin registers a new user manually" do
    visit new_admin_user_registration_path
    fill_in "Name", with: 'Jane Doe'
    fill_in "Email", with: 'jdoe@testaccount.com'
    fill_in "Zip Code", with: '44114'
    fill_in "Password", with: 'abc123'
    click_button "Save Person"
    current_url.should include('/admin/people')
    page.should have_content('Thank you for registering with The Civic Commons')
    ActionMailer::Base.deliveries.length.should == 2
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    FactoryGirl.create(:normal_person)
    visit admin_people_path
    page.should have_link('Confirm')
  end

  scenario "an admin wants to be able to confirm users that have signed up but have not received or completed the confirmation letter process" do
    jose = FactoryGirl.create(:normal_person, name: 'Jose Doe')
    visit admin_people_path
    click_link('Confirm')
    visit admin_people_path
    jose.confirmed?
  end

end
