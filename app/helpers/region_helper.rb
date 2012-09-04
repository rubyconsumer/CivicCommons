module RegionHelper

  # Region(metrocode) of CivicCommons
  def cc_metro_region
    510
  end

  def region_tab_image_url
    "http://s3.amazonaws.com/#{S3Config.bucket.to_s}/images-regions/#{default_region}.png"
  end

  # Set up the Default Region for the User
  # If one is not given, default to 510 - Cleveland-Akron (Canton) OH
  # This method sets the region if the region param is supplied. Otherwise reads it from database or cookie
  def default_region(region = nil)
    if region.blank?
      region = user_region
    else
      current_person.set_default_region(params[:metrocode]) if signed_in?
      cookies.permanent[:default_region] = {:value => "#{region}"}
    end

    return region.present? ? region.to_i : nil
  end

  def current_region
    @current_region ||= MetroRegion.find_by_metrocode(default_region)
  end

  # Weather a user is logged in or not, we need to figure out if they have a region filter selected.
  # * check the database, if logged in
  # * check the cookie, if not logged in
  def user_region
    if signed_in?
      current_person.default_region
    elsif cookies[:default_region].present?
      cookies[:default_region]
    else
      nil
    end
  end
end
