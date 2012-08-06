class Admin::RegionsController < Admin::DashboardController

  def new
    @region = Region.new(params[:region])
  end

  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find params[:id]
    if @region.update_attributes(params[:region])
      redirect_to "/admin/regions", :notice => "Region updated"
    else
      render :edit
    end
  end

  def create
    @region = Region.create params[:region]
    if @region.save
      redirect_to "/admin/regions", :notice => "Region created"
    else
      render :new, :notice => "oh no"
    end
  end

  def index
    @regions = Region.all
  end

end
