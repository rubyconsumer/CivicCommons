class Admin::ContentItemsController < Admin::DashboardController

  #GET admin/content_items
  def index
    @content_items = ContentItem.all
  end

  def new
    @content_item = ContentItem.new(params[:content_item])
    @content_item.inspect
  end

  def create
    ActiveRecord::Base.transaction do
      @content_item = ContentItem.new(params[:content_item])

      @content_item.save!

      respond_to do |format|
        format.html { redirect_to(admin_content_item_path(@content_item), :notice => "Your content item has been created!") }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { render new_admin_content_item_path }
    end
  end

  def show
    @content_item = ContentItem.find(params[:id])
  end

  def destroy
    @content_item = ContentItem.find(params[:id])
    @content_item.destroy
    flash[:notice] = "Successfully deleted content item"
    redirect_to admin_content_items_path
  end
end
