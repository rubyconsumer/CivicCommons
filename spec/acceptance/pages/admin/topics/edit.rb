module CivicCommonsDriver
  module Pages
    class Admin
      class Topics
        class Edit
          extend Page
          add_button(:update_topic, "Update Topic")
          def submit_form
            click_update_topic
          end
        end
      end
    end
   end
end
