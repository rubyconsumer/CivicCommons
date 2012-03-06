class Admin::ContentItemLinksController < Admin::DashboardController
  before_filter :get_content_item
  #GET admin/content_items/123/links
  def index
    @links = @content_item.links
  end
  
  def new
    @link = @content_item.links.build
  end
  
  def edit
    @link = @content_item.links.find(params[:id])
  end
  
  def create
    @link = @content_item.links.build(params[:content_item_link])
    if @link.save
      redirect_to admin_content_item_content_item_links_path(@content_item)
    else
      render :action => :new
    end
  end
  
  def update
    @link = @content_item.links.find(params[:id])
    if @link.update_attributes(params[:content_item_link])
      redirect_to admin_content_item_content_item_links_path(@content_item)
    else
      render :action => :edit
    end
  end
  
  
  def destroy
    @content_item.links.destroy(params[:id])
    redirect_to admin_content_item_content_item_links_path(@content_item)
  end
  
private
  def get_content_item
    @content_item = ContentItem.find(params[:content_item_id])
  end
end
