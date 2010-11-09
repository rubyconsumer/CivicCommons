class Api::ContributionsController < ActionController::Base
  respond_to :json


  def index

    contributions =
      Api::Contributions.for_person_by_people_aggregator_id(params[:id], request)

    if contributions
      respond_with contributions
    else
      head :status => 404
    end
  end


end

