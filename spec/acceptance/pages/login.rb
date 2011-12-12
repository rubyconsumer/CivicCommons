module CivicCommonsDriver
module Pages
  class Login
    SHORT_NAME = :login
    LOCATION = '/people/login'
    include Page
    add_field :email, "Email"
    add_field :password, "Password"

    add_link :login_with_facebook, "Login with Facebook", :home
    add_button :login, "Login", :home
  end
end
end
