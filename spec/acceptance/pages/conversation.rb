module CivicCommonsDriver
module Pages
class Conversation
  class Start
    SHORT_NAME = :start_conversation
    include Page 
    add_field(:title, "Title")
    add_field(:summary, "Summary")
    add_field(:content, "conversation[contributions_attributes][0][content]")
    add_field(:postal_code, "Zip Code")
    add_button(:start_my_conversation, "Start My Conversation", :invite_a_friend) 

    def fill_in_conversation
      fill_in_title_with "Frank"
      fill_in_summary_with "stufffff!"
fill_in_content_with "COOL! THIS IS AWESOME"
      fill_in_postal_code_with "48867"
      save_and_open_page
      select_issue "They are important"
    end
    def select_issue issue
      within "fieldset.issues" do
        check issue
      end
    end
    def submit
      click_start_my_conversation_button  
    end
  end
end
end
end
