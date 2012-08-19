class MetroRegionsController < ApplicationController
  include RegionHelper
  
  def filter
    default_region(params[:metrocode])
    redirect_to_back(conversations_url)
  end
end