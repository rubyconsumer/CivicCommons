class FacebookAuthPage < PageObject
  include Facebookable
  def sign_in
    stub_facebook_auth
    @page.click_link_or_button 'Sign in with Facebook'
  end

  def link_account
    stub_facebook_auth
    @page.click_link_or_button "Link my account with Facebook"
  end

  def click_connect_with_facebook
    stub_facebook_auth
    @page.click_link_or_button "Connect with Facebook"
  end


  def visit_callback
    @page.visit '/people/auth/facebook/callback'
  end

end
