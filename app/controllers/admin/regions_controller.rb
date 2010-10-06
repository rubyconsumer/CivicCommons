class Admin::RegionsController < Admin::DashboardController

  def new
    @region = Region.new
  end 

end
