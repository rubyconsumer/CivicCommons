module CivicCommonsDriver
  class Header
    include Page
    has_link(:settings, "Settings", :edit_profile_page)
    has_link(:logout, "Logout", :home)
    def user_profile_picture
      page.find('#login-status a img')['src']
    end


  end
end
