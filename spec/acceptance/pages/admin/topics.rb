module CivicCommonsDriver
  module Pages
    class Admin
      class Topics 
        extend Page
        add_link_for(:edit, "Edit", Pages::Admin::Topics::Edit)
        add_link_for(:delete, "Delete", Pages::Admin::Topics)

        def delete_topic topic
          delete topic 
          accept_alert
        end
      end
    end
  end
end
