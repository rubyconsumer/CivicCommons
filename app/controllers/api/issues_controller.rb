class Api::IssuesController < ActionController::Base
  respond_to :json


  def index

    contributed_issues =
      Api::ContributedIssues.for_person_by_email(params[:email])

    respond_with contributed_issues
  end


end

