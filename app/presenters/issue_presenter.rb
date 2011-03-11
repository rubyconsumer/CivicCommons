class IssuePresenter < PresenterBase

  def url
    issue_url(@object, host: request.host)
  end

end

