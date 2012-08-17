module RegionHelper
  # Set up the Default Region for the User
  # If one is not given, default to 510 - Cleveland-Akron (Canton) OH
  def default_region(region=510)
    region = 510 if region.blank?
    cookies.permanent[:default_region] = {:value => "#{region}"}
  end
end
