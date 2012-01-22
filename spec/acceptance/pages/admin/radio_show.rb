module CivicCommonsDriver
  module Pages
    class Admin
      class RadioShow
        SHORT_NAME = :admin_radio_shows
        include Page

        add_link_for(:edit, "Edit", :admin_radio_shows_edit)
        add_link_for(:add_host_or_guest, 'Add Host/Guest', :admin_content_items_people)

        class Edit
          SHORT_NAME = :admin_radio_shows_edit
          include Page
          has_field(:page_title, "Page Title")
          has_field(:meta_description, "Page Description")
          has_field(:meta_tags, "Page Meta Tags")
          has_button(:update_content_item, "Update Content item")
        end
      end
    end
  end
end
