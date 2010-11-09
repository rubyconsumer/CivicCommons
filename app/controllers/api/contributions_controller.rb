class Api::ContributionsController < ActionController::Base
  respond_to :json


  def index

    contributions =
      Api::Contributions.for_person_by_people_aggregator_id(params[:id], request)

    if contributions
      if params[:per_page]
        respond_with contributions.paginate(per_page: params[:per_page], page: params[:page])
      else
        respond_with contributions
      end
    else
      head :status => 404
    end
  end


end

