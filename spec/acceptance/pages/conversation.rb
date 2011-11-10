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
    add_field(:title, "Title")
    add_field(:summary, "Summary")
    add_wysiwyg_editor_field(:content, "conversation_contributions_attributes_0_content")
    #add_field(:postal_code, "Zip Code")
    add_button(:start_my_conversation, "Start My Conversation", :invite_a_friend) 

    def fill_in_conversation
      fill_in_title_with "Frank"
      fill_in_summary_with "stufffff!"
      fill_in_content_with "COOL! THIS IS AWESOME"
      #fill_in_postal_code_with "48867"
      select_issue "They are important"
    end
    def select_issue issue
      within "fieldset.issues" do
        check issue
      end
    end
    def submit_conversation
      fill_in_conversation
      click_start_my_conversation_button
    end
  end
end
end
end
