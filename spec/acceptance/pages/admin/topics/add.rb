module CivicCommonsDriver
  module Pages
    class Admin
      class Topics 
        class Add
          extend Page
          add_button(:create_topic, "Create Topic")
          def submit_form
            click_create_topic
          end

          def fill_name_with(value)
            fill_in 'Name', with: value
          end
        end
      end
    end
  end
end
