class ConversationPage < PageObject

  def contribution_text_area
    find('textarea#contribution_content')
  end

  def visit_page(conversation)
    visit conversation_path(conversation)
  end

  def visit_node(conversation, contribution)
    visit "#{conversation_path(conversation)}#node-#{contribution.id}"
  end

  def post_to_the_conversation
    find_link 'Post to this Conversation'
  end

  def add_content_to_contribution(content)
    if has_css?('textarea#contribution_content', visible: true)
      fill_in 'contribution_content', :with => content
    end
  end

  def click_post_to_the_conversation
    post_to_the_conversation.click
  end

  def click_preview
    find('#contribution_submit', visible: true).click
  end

  def click_submit_contribution
    find('#contribution_submit', visible: true).click
  end

  def click_cancel_contribution
    find('a.cancel', visible: true).click
  end

  def respond_with_attachment(conversation, content)
    find('#image_tab', visible: true).click
    within("#conversation-#{conversation.id}-new-attached_file") do
      attach_file('contribution_attachment', File.expand_path('test/fixtures/cc_logos.pdf'))
      find('#contribution_content', visible: true)
      fill_in('contribution_content', with: content)
    end
  end

  def respond_with_suggestion(conversation, content)
    find('#suggested_action_tab', visible: true).click
    within("#conversation-#{conversation.id}-new-suggested_action") do
      find('#contribution_content', visible: true)
      fill_in('contribution_content', with: content)
    end
  end

  def respond_with_question(conversation, content)
    find('#question_tab', visible: true).click
    within("#conversation-#{conversation.id}-new-question") do
      find('#contribution_content', visible: true)
      fill_in('contribution_content', with: content)
    end
  end

  def preview_attachment(conversation, content)
    visit_page(conversation)
    click_post_to_the_conversation
    respond_with_attachment(conversation, content)
    click_preview
  end

  def preview_suggestion(conversation, content)
    visit_page(conversation)
    click_post_to_the_conversation
    respond_with_suggestion(conversation, content)
    click_preview
  end

  def preview_question(conversation, content)
    visit_page(conversation)
    click_post_to_the_conversation
    respond_with_question(conversation, content)
    click_preview
  end

  def respond_to_contribution(contribution)
    click_link("Respond to #{Person.find(contribution.owner).first_name}")
  end

  def has_preview_contribution_text?(content)
    if find("#cboxLoadedContent div.comment div.content p") && page.has_content?(content)
      return true
    else
      false
    end
  end

  def has_contribution?(content)
    if has_content?(content)
      return true
    else
      false
    end
  end

  def has_submit_contribution_button?
    if has_css?('#contribution_submit')
      return true
    else
      false
    end
  end

  def has_cancel_contribution_link?
    if has_css?('a.cancel')
      return true
    else
      false
    end
  end

  def has_contribution_modal_present?
    if find('#cboxContent')
      return true
    else
      false
    end
  end

  def has_link?(link_name)
    if find_link(link_name)
      return true
    else
      false
    end
  end

  def has_active_tab?(tab_name)
    if find('.tab-active').text == tab_name
      return true
    else
      false
    end
  end

  def preview_contribution(conversation, content)
    visit_page(conversation)
    click_post_to_the_conversation
    add_content_to_contribution(content)
    click_preview
  end

end
