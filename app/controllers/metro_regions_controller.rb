class MetroRegionsController < ApplicationController
  include RegionHelper

  def filter
    default_region(params[:metrocode])
    redirect_to_back(conversations_url)
  end

  def cancel_regions_filter
    if signed_in?
      current_person.default_region = nil
      current_person.save!
    end
    cookies.delete( :default_region )
    redirect_to_back(conversations_url)
  end

end
