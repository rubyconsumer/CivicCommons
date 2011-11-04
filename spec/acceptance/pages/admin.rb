module CivicCommonsDriver module Pages

class Admin
  SHORT_NAME = :admin
  LOCATION = '/admin'
  include Page
  add_link(:add_issue, "Add Issue", :admin_add_issue)
  add_link(:topics, "Topics", :admin_topics)
  add_link(:add_topic, "Add Topic", :admin_add_topic)
end

end end
