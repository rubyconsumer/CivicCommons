require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create New Account Using Facebook Credentials", %q{
  In order to use CivicCommons
  As a visitor of CivicCommons
  I want to create a new account using Facebook Credentials
} do

  include Facebookable
  before do
    stub_facebook_auth
    sign_out
  end

  scenario "Creating an account using Facebook credentials" do
    pending
    start_registering_an_account
    fill_in_zip_code_field_with '12345'
    follow_connect_with_facebook_link
  end
  scenario "email is taken" do
    pending
    create_user :user_with_facebook_email
    start_registering_an_account
    follow_connect_with_facebook_link
    email_address_taken_modal.should be_visible
  end
end
