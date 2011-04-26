class ConversationPage < PageObject


  def self.setup_conversation_page
    @contribution = Factory.create(:comment, override_confirmed: true)
    @conversation = @contribution.conversation
  end

  def contribution_text_area
    find('textarea#contribution_content')
  end

  def visit_page
    visit conversation_path(@conversation)
  end

  def post_to_the_conversation
    find("conversation-action-link-#{@conversation.id}")
  end

  def click_post_to_the_conversation
    post_to_the_conversation.click
  end

end
