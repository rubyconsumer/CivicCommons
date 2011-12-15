module CivicCommonsDriver
  module Pages
    class Admin
      class Conversations
        SHORT_NAME = :admin_conversations
        include Page
        add_link_for(:edit, "Edit", :admin_conversations_edit)
        class Edit
          SHORT_NAME = :admin_conversations_edit
          include Page
          has_field(:page_title, "Page Title")
          has_field(:meta_description, "Page Description")
          has_field(:meta_tags, "Page Meta Tags")
          has_button(:update_conversation, "Update Conversation")
        end
      end
    end
  end
end
