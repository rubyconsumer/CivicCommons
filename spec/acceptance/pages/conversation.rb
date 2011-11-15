module CivicCommonsDriver
module Pages
class Conversation
  class View
    SHORT_NAME = :view_conversation
    include Page
  end
  class Start
    SHORT_NAME = :start_conversation
    include Page
    has_field :title, "Title"
    has_field :summary, "Summary"

    has_link :show_add_link_field, "contribution-add-link"
    has_field :link_to_related, "conversation[contributions_attributes][0][url]"

    has_wysiwyg_editor_field :content, "conversation_contributions_attributes_0_content"
    has_button :start_my_conversation, "Start My Conversation", :invite_a_friend
    has_button :start_invalid_conversation, "Start My Conversation"

    def fill_in_conversation options = {}
      fill_in_title_with "Frank"
      fill_in_summary_with "stufffff!"
      fill_in_content_with "COOL! THIS IS AWESOME"
      select_issue "They are important"
      add_link options[:link_to_related_website] if options.key? :link_to_related_website
    end

    def add_link link
      follow_show_add_link_field_link
      fill_in_link_to_related_with link
    end

    def select_issue issue
      within "fieldset.issues" do
        check issue
      end
    end
    def submit_conversation(options = {})
      fill_in_conversation options
      click_start_my_conversation_button
    end
    def submit_invalid_conversation options={}
      fill_in_conversation options
      click_start_invalid_conversation_button
    end
    def has_an_error_for? field 
      has_content? "The link you provided is invalid"
    end
  end
end
end
end
