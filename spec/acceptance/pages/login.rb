module CivicCommonsDriver
module Pages
  class Login
    SHORT_NAME = :login
    LOCATION = '/people/login'
    include Page
    include Facebookable

    add_field :email, "Email"
    add_field :password, "Password"

    add_link :login_with_facebook, "Sign in with Facebook", :home
    add_button :login, "Login", :home
    def login user
      if user.on_facebook_auth?
        stub_facebook_auth_for user
        follow_login_with_facebook_link
        wait_until { page.has_content? user.name }
      else
        login_without_facebook user
      end
    end
    def login_without_facebook user
        fill_in_email_with user.email
        fill_in_password_with user.password
        click_login_button
    end
  end

end
end
