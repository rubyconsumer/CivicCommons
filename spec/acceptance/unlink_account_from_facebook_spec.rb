require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Unlink Account From Facebook", %q{
  In order to not participate using Facebook anymore
  As a current user who have already connected to Facebook
  I want to unlink my account
} do
  
  let (:facebook_auth_page)               { FacebookAuthPage.new(page) }
  let (:fb_unlinking_success_page)        { FbUnlinkingSuccessPage.new(page)}
  let (:before_facebook_unlinking_page)   { BeforeFacebookUnlinkingPage.new(page) }
  let (:settings_page)                    { SettingsPage.new(page) }
  let (:confirm_facebook_unlinking_page)  { ConfirmFacebookUnlinkingPage.new(page) }
  
  
  def given_a_registered_user_w_facebook_auth
    @person = Factory.create(:registered_user)
    @facebook_auth = Factory.build(:facebook_authentication)
    @person.link_with_facebook(@facebook_auth)
  end

  scenario "Unlinking" do
    # Given I am a registered Civic Commons user that have connected with Facebook
    given_a_registered_user_w_facebook_auth
    
    # And I am on the home page
    page.visit(homepage)
    
    # And I am logged in
    facebook_auth_page.sign_in
    
    # When I go to the settings page
    settings_page.visit(@person)
    
    # Then I should see the Unlink from Facebook link
    settings_page.should have_link 'Unlink from Facebook'
    
    # When I click on the Unlink from Facebook link
    settings_page.click_unlink_from_facebook
    
    # Then I should be prompted with a modal dialog of the consequences of unlnking, and if I want to continue or not
    confirm_facebook_unlinking_page.should be_visited
    
    # When I click yes
    confirm_facebook_unlinking_page.click_yes
    
    # Then I should see a modal dialog prompting me to update my login email and password and password confirmation
    before_facebook_unlinking_page.should be_visited
    
    # When I changed my email to a different email
    before_facebook_unlinking_page.fill_in 'person_email', :with => 'test1@test.com'
    
    # And I enter my password
    before_facebook_unlinking_page.fill_in 'person_password', :with => 'password123'
    
    # And I enter my password confirmation
    before_facebook_unlinking_page.fill_in 'person_password_confirmation', :with => 'password123'
    
    # And I click submit
    before_facebook_unlinking_page.click_link_or_button('Submit')
    
    # Then I should see an unlink confirmation modal dialog
    fb_unlinking_success_page.should be_displayed
    
    # And I should receive an email notification that I have change my email
    
  end
  scenario "a notification email is sent to me when I change my email when unlinking" do
    pending
  end
  
  context "failing" do
    pending
  end
end
