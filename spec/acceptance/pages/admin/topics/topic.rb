module CivicCommonsDriver module Pages
class Admin 
class Topic
  SHORT_NAME = :admin_topic
  include Page
  def for? topic
    has_content?("Name: #{topic.name}") && current_path == "/admin/topics/#{topic.id}"
  end
  class Edit
    SHORT_NAME = :admin_edit_topic
    include Page
    add_button(:update_topic, "Update Topic", :admin_topic)
    add_field(:name, "Name")
    def submit_topic name
      fill_in_name_with name
      click_update_topic_button
    end
  end
end

end end end
