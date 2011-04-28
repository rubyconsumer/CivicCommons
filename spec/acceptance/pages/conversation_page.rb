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
    has_css?('textarea#contribution_content', visible: true)
    fill_in 'contribution_content', :with => content
  end

  def click_post_to_the_conversation
    post_to_the_conversation.click
  end

  def respond_to_contribution(contribution)
    click_link("Respond to #{Person.find(contribution.owner).first_name}")
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

end
