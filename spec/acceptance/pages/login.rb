module CivicCommonsDriver
module Pages
  class Login
    SHORT_NAME = :login
    include Page
    location '/people/login'
    add_field :email, "Email"
    add_field :password, "Password"

    add_button :login, "Login", :home
  end
end
end
