require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "8457517 link local account with facebook", %q{
  In order use CivicCommons
  As an existing user with a local account
 ve I want to authenticate through Facebook
  So that I only have to remember one login and password
} do
  include Facebookable
  before do
    stub_facebook_auth
    sign_out
  end

  let (:facebook_auth_page) { FacebookAuthPage.new(page) }
  let (:settings_page)              { SettingsPage.new(page) }
  let (:fb_linking_success_page)    { FbLinkingSuccessPage.new(page) }
  let (:suggest_facebook_auth_page) { SuggestFacebookAuthPage.new(page) }
  let (:forgot_password_page)       { ForgotPasswordPage.new(page) }
  let (:fb_auth_forgot_password_modal_page) { FbAuthForgotPasswordModalPage.new(page)}

  def response_should_js_redirect_to(path)
    page.should contain "window.opener.location = '#{path}'"
  end

  def response_should_js_open_colorbox(path)
    page.should contain "$.colorbox({href:'#{path}'"
  end

  def suggestion_to_connect_to_facebook
    auth_modal = ".suggest-auth.facebook-auth"
    sleep 3
    if page.has_css? auth_modal
      page.find(auth_modal)
    else
      InvisibleObject.new
    end
  end
  class InvisibleObject
    def visible?
      false
    end
  end
  context "When I have not linked my account to Facebook" do
    scenario "use facebook email if conflicting", :js=>true do
      login_as :registered_user
      begin_connecting_to_facebook
      use_facebook_email
      sleep 2
      reload_logged_in_user
      logged_in_user.email.should == 'johnd@test.com'
    end

    scenario "I should be able to link my account to facebook from the 'accounts' page", :js=>true do
      login_as :registered_user, email: 'johnd@test.com'
      connect_account_to_facebook
      logged_in_user.should be_facebook_authenticated
      goto :edit_profile_page, :for => logged_in_user
      page.should_not have_link 'Connect with Facebook'
      sleep 3
      page.should have_link "Unlink from Facebook"
    end

    describe "Facebook suggest modal dialogue", :js=>true do
      scenario "should be displayed if I have not linked my account to facebook" do
        login_as :registered_user_who_hasnt_declined_fb
        suggestion_to_connect_to_facebook.should be_visible
      end

      scenario "should be not be displayed when I have declined the suggestion to link to Facebook", :js=>true do
        login_as :registered_user_who_hasnt_declined_fb
        suggestion_to_connect_to_facebook.should be_visible
        follow_decline_link
        page_header.follow_logout_link
        log_back_in
        suggestion_to_connect_to_facebook.should_not be_visible
      end

    end
  end

  context "When I already have linked my account to facebook previously" do

    scenario "I should be able to login using facebook and to existing account", :js=>true do
      login_as :registered_user_with_facebook_authentication
      page.should_not have_link 'Login to Civic Commons'
      page.should have_content "John Doe"
    end

    scenario "I should not be able to login using my existing account anymore", :js=>true do
      user = create_user :registered_user_with_facebook_authentication
      goto :login
      puts user.authentications
      login_without_facebook user
      save_and_open_page
      page.should have_content 'It looks like you registered using Facebook, please login with Facebook.'
    end

  end

  context "Facebook profile picture" do

    scenario "I should my facebook profile picture if I've connected to Facebook", :js=>true do
      login_as :registered_user_with_facebook_authentication
      page_header.user_profile_picture.should be_of "https://graph.facebook.com/12345/picture"
    end
  end

  context "Forgot password" do
    scenario "I should see a modal dialog prompting me to login to facebook.", :js=>true do
      create_user :registered_user_with_facebook_authentication
      forgot_password_page.visit
      forgot_password_page.enter_email('johnd@example.com')
      forgot_password_page.click_submit
      sleep 3
      response_should_js_open_colorbox(fb_auth_forgot_password_path)
      fb_auth_forgot_password_modal_page.visit
      page.should have_link "Sign in with Facebook"
    end
  end
  def connect_account_to_facebook
    begin_connecting_to_facebook
    submit
    reload_logged_in_user
  end
  def begin_connecting_to_facebook
    page_header.follow_settings_link :for => logged_in_user
    follow_connect_to_facebook_link
  end
  def follow_decline_link
    click_link "Continue without linking account"
  end
end
