module CivicCommonsDriver module Pages

class Admin
  SHORT_NAME = :admin
  LOCATION = '/admin'
  include Page
  add_link(:add_issue, "Add Issue", :admin_add_issue)
end

end end
