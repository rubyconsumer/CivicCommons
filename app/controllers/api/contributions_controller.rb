class Api::ContributionsController < ActionController::Base
  respond_to :json


  def index

    contributions =
      Api::Contributions.for_person_by_people_aggregator_id(params[:id], request)

    respond_with contributions
  end


end

