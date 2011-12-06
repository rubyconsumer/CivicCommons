module CivicCommonsDriver
  class Header
    include Page
    has_link(:settings, "Settings", :edit_profile_page)
  end
end
