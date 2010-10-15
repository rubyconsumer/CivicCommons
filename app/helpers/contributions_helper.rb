module ContributionsHelper
  def contribution_parent_page(contribution)
    if contribution.conversation
      conversation_path(contribution.conversation)
    else
      issue_path(contribution.issue)
    end
  end
end
