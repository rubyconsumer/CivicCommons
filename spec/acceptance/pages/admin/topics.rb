module CivicCommonsDriver module Pages
class Admin
class Topics
  SHORT_NAME = :admin_topics
  include Page
  add_link_for(:edit, "Edit", :admin_edit_topic)
  add_link_for(:delete, "Delete", :admin_topics)

  def delete_topic topic
    follow_delete_link_for topic
    accept_alert
  end

end
end
end end
