class Admin::RegionsController < Admin::DashboardController

  def new
    @region = Region.new
  end 

  def edit
    @region = Region.find(params[:id])
  end

  def update

  end

  def create
    @region = Region.create params[:region]
    if @region.save
      redirect_to "/admin", :notice => "Region created"
    else
      render :new
    end
  end

  def index
    @regions = Region.all
  end

end
