class IssuePresenter < PresenterBase
  def container_attribute
    "data-issue-id='#{id}'"
  end
end
