module CivicCommonsDriver
module Pages
class Admin
class ContentItems
  SHORT_NAME = :admin_content_items
  include Page
  
  class Show
    SHORT_NAME = :admin_content_item
    include Page
  end
  

  class Add
    SHORT_NAME = :admin_add_content_item
    include Page
    include Database

    has_field(:page_title, 'content_item_page_title')
    has_field(:meta_description, 'Page Description:')
    has_field(:meta_tags, 'Page Meta Tags:')
    has_field(:title, 'content_item_title')
    has_field(:published, 'Publish On (mm/dd/yyyy)')
    
    has_button(:create_content_item, 'Create Content item', :admin_content_item)
    has_button(:create_content_item_while_in_invalid_state, 'Create Content item', :admin_add_content_item)
    # content_type needed
    # author needed

    has_field(:external_link, 'content_item_external_link')    
    has_wysiwyg_editor_field(:summary, 'content_item_summary')
    has_wysiwyg_editor_field(:body, 'content_item_body')
    has_field(:embed_code, 'Embed code')

    def attach_image file_name
      attach_file 'content_item[image]', File.join(attachments_path, file_name)
    end

    def select_topic topic
      check topic
    end
    def has_reminder_to_add_topics?
      within '#error_explanation' do
        has_content? "Please select at least one Topic"
      end
    end
    def fill_in_content_item_with details
      details = defaults.merge(details)

      fill_in_page_title_with details[:page_title]
      fill_in_meta_description_with details[:meta_description]
      fill_in_meta_tags_with details[:meta_tags]
      fill_in_title_with details[:title]
      details[:topics].each do | topic |
        select_topic topic.name
      end
      fill_in_external_link_with details[:external_link]
      fill_in_summary_with details[:summary]
      fill_in_body_with details[:body]
      fill_in_embed_code_with details[:embed_code]
      attach_image details[:image]
      fill_in_summary_with details[:summary]
    end
    def defaults
      {
        :page_title => 'titlehere',
        :meta_description => 'metadesc here',
        :meta_tags => 'meta tag here',
        :title => "WOOwoop",
        :topics => [database.first_topic],
        :external_link => "http://test.com",
        :summary => 'Summary here',
        :body => 'Body here',
        :embed_code => 'Embed code here',
        :image => "imageAttachment.png"
      }
    end
  end

end
end end end
