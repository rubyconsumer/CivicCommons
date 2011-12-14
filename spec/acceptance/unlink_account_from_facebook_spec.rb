require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Unlink Account From Facebook", %q{
  In order to not participate using Facebook anymore
  As a current user who have already connected to Facebook
  I want to unlink my account
} do
  include Facebookable
  let (:facebook_auth_page)               { FacebookAuthPage.new(page) }
  let (:fb_unlinking_success_page)        { FbUnlinkingSuccessPage.new(page)}
  let (:before_facebook_unlinking_page)   { BeforeFacebookUnlinkingPage.new(page) }
  let (:settings_page)                    { SettingsPage.new(page) }
  let (:confirm_facebook_unlinking_page)  { ConfirmFacebookUnlinkingPage.new(page) }
  
  
  before do
    stub_facebook_auth
  end

  scenario "Unlinking process", :js=>true do
    Notifier.deliveries  = []
    login_as :registered_user_with_facebook_authentication
    goto :edit_profile_page, :for=>logged_in_user
    puts url
    save_and_open_page
    unlink_from_facebook email: "johnd-new-email@example.com"

    fb_unlinking_success_page.should be_displayed
    Notifier.deliveries.length.should == 1
    Notifier.deliveries.first.to.should contain 'johnd@example.com'
    Notifier.deliveries.first.to.should contain 'johnd-new-email@example.com'
    Notifier.deliveries.first.subject.should contain "You've recently changed your email with The Civic Commons"
  end

  scenario "Should throw validation error when user does not enter password", :js=>true do
    login_as :registered_user_with_facebook_authentication
    goto :edit_profile_page, :for => logged_in_user
    begin_unlinking_from_facebook
    click_submit_invalid_form_button
    current_page.should have_password_required_error
    #current_page.should have_css 
  end
  def unlink_from_facebook options
    begin_unlinking_from_facebook
    fill_in_email_field_with options[:email]
    fill_in_password_field_with "password123"
    fill_in_confirm_password_field_with "password123"
    click_submit_button
  end
  def begin_unlinking_from_facebook
    follow_unlink_from_facebook_link
    follow_confirm_unlink_from_facebook_link
  end
end
