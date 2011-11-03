module CivicCommonsDriver module Pages class Admin 
class Issues
  SHORT_NAME = :admin_view_issues
  include Page
  class Add
    SHORT_NAME = :admin_add_issue
    include Page
    add_field(:name, 'Name')
    add_wysiwyg_editor_field(:summary, 'issue[summary]')
    add_field(:zip_code, 'Zip code')
    add_button(:create_issue, 'Create Issue', :admin_view_issues)
    add_button(:create_issue_while_in_invalid_state, 'Create Issue', :admin_add_issue)
    def attach_image file_name
      attach_file 'issue[image]', File.join(attachments_path, file_name) 
    end
    def select_topic topic
      check topic  
    end
    def has_reminder_to_add_topics?
      within '#error_explanation' do
        has_content? "Topics can't be blank"
      end
    end
    def fill_in_issue_with details
      details = defaults.merge details

      fill_in_name_with details[:name]
      details[:topics].each do | topic |
        select_topic topic.name
      end
      attach_image details[:image]
      fill_in_summary_with details[:summary]
      fill_in_zip_code_with details[:postal_code]
    end
    def defaults
      {
        :name => "WOOwoop",
        :summary => "SUMMMED",
        :topics => [Topic.first],
        :image => "imageAttachment.png",
        :postal_code => "48867"
      }
    end
  end
    
end
end end end
