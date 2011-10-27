class ConversationPage < PageObject

  def visit_page(conversation)
    visit conversation_path(conversation)
  end

  def visit_node(conversation, contribution)
    visit conversations_node_show_path(conversation, contribution)
  end

  def contribution_subthread(contribution)
    "#show-contribution-#{contribution.id} .thread-list"
  end
end
