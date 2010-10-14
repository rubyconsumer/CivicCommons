class Api::SubscriptionsController < ActionController::Base
  respond_to :json


  def index

    subscribed_items =
      Api::SubscribedItems.for_person_by_people_aggregator_id(params[:id], request)

    respond_with subscribed_items
  end


end

