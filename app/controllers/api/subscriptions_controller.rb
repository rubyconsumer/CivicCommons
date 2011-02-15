class Api::SubscriptionsController < ActionController::Base
  respond_to :json


  def index

    subscribed_items =
      Api::SubscribedItems.for_person_by_id(params[:id], request)

    if subscribed_items
      respond_with subscribed_items
    else
      head :status => 404
    end
  end


end

