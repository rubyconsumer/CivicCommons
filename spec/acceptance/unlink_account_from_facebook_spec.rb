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
    @person = Factory.create(:registered_user, :email => 'johnd@example.com')
    @facebook_auth = Factory.build(:facebook_authentication)
    @person.link_with_facebook(@facebook_auth)
  end

  scenario "Unlinking process" do
    # Given I am a registered user at The Civic Commons that has connected with Facebook
    given_a_registered_user_w_facebook_auth
    
    # And no email in the queue
    Notifier.deliveries  = []
    
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
    before_facebook_unlinking_page.fill_in 'person_email', :with => 'johnd-new-email@example.com'
    
    # And I enter my password
    before_facebook_unlinking_page.fill_in 'person_password', :with => 'password123'
    
    # And I enter my password confirmation
    before_facebook_unlinking_page.fill_in 'person_password_confirmation', :with => 'password123'
    
    # And I click submit
    before_facebook_unlinking_page.click_link_or_button('Submit')
    
    # Then I should see an unlink confirmation modal dialog
    fb_unlinking_success_page.should be_displayed
    
    # And 1 email change confirmation should be sent
    Notifier.deliveries.length.should == 1
    
    # And the email should be sent to the old email
    Notifier.deliveries.first.to.should contain 'johnd@example.com'
    
    # And the email should also be sent to the new email
    Notifier.deliveries.first.to.should contain 'johnd-new-email@example.com'
    
    # And the email should have the correct subject
    Notifier.deliveries.first.subject.should contain "You've recently changed your email with The Civic Commons"
  end
  
  scenario "Should throw validation error when user does not enter password" do
    # Given I am a registered user at The Civic Commons that has connected with Facebook
    given_a_registered_user_w_facebook_auth

    # And I am on the home page
    page.visit(homepage)
    
    # And I am logged in
    facebook_auth_page.sign_in
    
    # When I go to the settings page
    settings_page.visit(@person)
    
    # And I click on the Unlink from Facebook link
    settings_page.click_unlink_from_facebook
    
    # And I click yes
    confirm_facebook_unlinking_page.click_yes
        
    # And I click submit
    before_facebook_unlinking_page.click_link_or_button('Submit')
    
    # And I should see an error on missing password
    before_facebook_unlinking_page.should have_selector('.field-with-error input#person_password')
  end
end
