class ContributionPresenter < PresenterBase

  def parent
    (@object.conversation || @object.issue)
  end

  def parent_conversation?
    parent.class.name == "Conversation"
  end


  def parent_issue?
    parent.class.name == "Issue"
  end

  def parent_image
    parent.image
  end

  def parent_title
    if parent.respond_to?(:title)
      parent.title
    else
      parent.name
    end
  end

  def parent_url
    if parent_conversation?
      conversation_url(parent, host: request.host)
    elsif parent_issue?
      issue_url(parent, host: request.host)
    end
  end

end
