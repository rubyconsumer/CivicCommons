class Api::IssuesController < ActionController::Base
  respond_to :json


  def index
    Rails.logger.debug params.inspect

    contributed_issues =
        Api::ContributedIssues.for_person_by_people_aggregator_id(params[:id], request)

    respond_with contributed_issues
  end


end

