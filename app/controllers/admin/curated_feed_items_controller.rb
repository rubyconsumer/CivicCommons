class Admin::CuratedFeedItemsController < Admin::DashboardController

  # GET /admin/feeds/1/items
  #def index
    #@items = CuratedFeedItem.where(feed_id: params[:feed_id]).order('title ASC')
  #end

  # GET /admin/feeds/1/items/1
  def show
    @feed = CuratedFeed.find(params[:feed_id])
    @item = CuratedFeedItem.find(params[:id])
  end

  # GET /admin/feeds/1/items/new
  #def new
    #@item = CuratedFeedItem.new(feed_id: params[:feed_id])
  #end

  # GET /admin/feeds/1/items/1/edit
  def edit
    @item = CuratedFeedItem.find(params[:id])
  end

  # POST /admin/feeds/1/items
  def create
    @feed = CuratedFeed.find(params[:curated_feed_id])
    @item = CuratedFeedItem.new(params[:curated_feed_item])
    @item.feed = @feed
    @item.save
    redirect_to(admin_curated_feed_path(@feed))
    #render 'admin/curated_feeds/show'
  end

  # PUT /admin/feeds/1/items/1
  def update
    @feed = CuratedFeed.find(params[:feed_id])
    @item = CuratedFeedItem.find(params[:id])
    @item.attributes = params[:item]

    if @item.save
      redirect_to(admin_item_path(@feed, @item), :notice => 'Feed item was successfully updated.')
    else
      render "edit"
    end
  end

  # DELETE /admin/feeds/1/items/1
  def destroy
    @feed = CuratedFeed.find(params[:feed_id])
    @item = CuratedFeedItem.find(params[:id])
    @item.destroy
    redirect_to(admin_items_path(@feed))
  end
end
