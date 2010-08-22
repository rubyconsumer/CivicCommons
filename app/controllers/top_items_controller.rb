class TopItemsController < ApplicationController
  respond_to :html, :xml, :json    

  def newest
    @top_items = TopItem.newest_items(params[:limit] || 10)
    respond_with(@top_items)
  end
  
  def highest_rated
    @highest_rated = TopItem.highest_rated(params[:limit] || 10)
    respond_with(@highest_rated)
  end
  
  def most_visited
  end
end
