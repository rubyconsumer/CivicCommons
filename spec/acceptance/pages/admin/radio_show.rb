module CivicCommonsDriver
  module Pages
    class Admin
      class RadioShow
        SHORT_NAME = :admin_radio_shows
        include Page
        
        add_link_for(:edit, "Edit", :admin_radio_shows_edit)
        add_link_for(:add_host_or_guest, 'Add Host/Guest', :admin_content_items_people)
        add_link_for(:manage_links, 'manage', :admin_content_item_links)
        has_button(:update_radioshow_descriptions, "Update RadioShow Descriptions", :admin_radio_shows)
        has_field(:description_long, "Description long")
        has_field(:description_short, "Description short")
        
        def follow_show_link_for radioshow
          click_link radioshow.title
          set_current_page_to :admin_radio_shows_detail
        end

        def fill_in_radio_show_descriptions_with details
          details = defaults.merge(details)

          fill_in_description_short_with details[:description_short]
          fill_in_description_long_with details[:description_long]
        end

        def defaults
          {
            :description_short => 'short description',
            :description_long => 'long description',
          }
        end

        class Edit
          SHORT_NAME = :admin_radio_shows_edit
          include Page
          has_field(:page_title, "Page Title")
          has_field(:meta_description, "Page Description")
          has_field(:meta_tags, "Page Meta Tags")
          has_button(:update_content_item, "Update Content item")
        end
        
        class Show
          SHORT_NAME = :admin_radio_shows_detail
          include Page
          has_link(:manage_links, "Manage/Add RadioShow Links", :admin_content_item_links)
        end
        
      end
    end
  end
end
