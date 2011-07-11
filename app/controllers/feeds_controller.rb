class FeedsController < ApplicationController

  # GET /feeds/1
  def show
    @feed = CuratedFeed.find(params[:id])
    render :show
  rescue ActiveRecord::RecordNotFound => e
    redirect_to feeds_path, format: :html
  end

end
