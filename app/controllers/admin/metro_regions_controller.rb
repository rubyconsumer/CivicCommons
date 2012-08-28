class Admin::MetroRegionsController < Admin::DashboardController

  def new
    @region = MetroRegion.new(params[:region])
  end

  def edit
    @region = MetroRegion.find(params[:id])
  end

  def update
    @region = MetroRegion.find params[:id]

    if @region.update_attributes(params[:metro_region])
      redirect_to "/admin/metro_regions", :notice => "Region updated"
    else
      render :edit
    end
  end

  def create
    @region = MetroRegion.create params[:region]
    if @region.save
      redirect_to "/admin/metro_regions", :notice => "Region created"
    else
      render :new, :notice => "oh no"
    end
  end

  def index
    @regions = MetroRegion.all
  end

  def display_names
    @regions = MetroRegion.group(:display_name)
    render :display_names
  end

  def edit_display_names
    @region = MetroRegion.find(params[:id])
  end

  def update_display_names
    @region = MetroRegion.find params[:id]
    MetroRegion.update_all ["display_name = ?", params[:metro_region][:display_name]], ["display_name = ?", @region.display_name]

    @region.reload
    @region.update_amazon_slideout_image
    redirect_to "/admin/metro_regions/display_names", :notice => "Region updated"
  end

end
