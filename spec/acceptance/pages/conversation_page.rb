class ConversationPage < PageObject

  def contribution_text_area
    find('textarea#contribution_content')
  end

end
