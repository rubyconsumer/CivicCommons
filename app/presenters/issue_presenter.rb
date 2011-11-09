class IssuePresenter < PresenterBase


  def filed_under
    @object.topics.map(&:name).join(", ")
  end

end

