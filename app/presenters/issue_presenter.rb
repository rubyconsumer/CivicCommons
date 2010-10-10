class IssuePresenter < Presenter::Base
  include Rails.application.routes.url_helpers


  def url
    issue_url(@object, host: request.host)
  end


end

