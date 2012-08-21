module RegionHelper
  
  # Region(metrocode) of CivicCommons
  def cc_metro_region
    510
  end
  
  # Set up the Default Region for the User
  # If one is not given, default to 510 - Cleveland-Akron (Canton) OH
  # This method sets the region if the region param is supplied. Otherwise reads it from database or cookie
  def default_region(region = nil)
    if region.blank?
      if signed_in? 
        region = current_person.default_region
      elsif cookies[:default_region].present?
        region = cookies[:default_region] 
      end
    else
      current_person.set_default_region(params[:metrocode]) if signed_in?
      cookies.permanent[:default_region] = {:value => "#{region}"}
    end

    return region.present? ? region.to_i : cc_metro_region
  end
  
  def current_region
    @current_region ||= MetroRegion.find_by_metrocode(default_region)
  end
end
