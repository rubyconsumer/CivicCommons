module CivicCommonsDriver module Pages class Admin
class Topics 
  class Add
    SHORT_NAME = :admin_add_topic
    include Page
    add_button(:create_topic, "Create Topic", :admin_topic)
    add_button(:create_invalid_topic, "Create Topic", :admin_add_topic)
    add_field(:name, "Name")
    def submit_topic name
      fill_in_name_with name
      click_create_topic_button
    end
    def submit_blank_topic
      click_create_invalid_topic_button
    end

    def has_an_error?
      has_css? '#error_explanation'
    end
  end
end end end end
