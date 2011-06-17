class Admin::CuratedFeedItemsController < Admin::DashboardController

  # GET /admin/curated_feeds/1/items
  def all
    @curated_feed_items = CuratedFeedItem.order('curated_feed_id ASC, name ASC')
    render 'index'
  end

  # GET /admin/curated_feeds/1/items
  def index
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_items = CuratedFeedItem.where(curated_feed_id: @curated_feed.id).order('name ASC')
  end

  # GET /admin/curated_feeds/1/items/1
  def show
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.find(params[:id])
  end

  # GET /admin/curated_feeds/1/items/new
  def new
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.new(curated_feed: @curated_feed)
  end

  # GET /admin/curated_feeds/1/items/1/edit
  def edit
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.find(params[:id])
  end

  # POST /admin/curated_feeds/1/items
  def create
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.new(params[:curated_feed_item])
    @curated_feed_item.curated_feed = @curated_feed

    if @curated_feed_item.save
      redirect_to(admin_curated_feed_item_path(@curated_feed, @curated_feed_item), :notice => 'Feed item was successfully created.')
    else
      render "new"
    end
  end

  # PUT /admin/curated_feeds/1/items/1
  def update
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.find(params[:id])
    @curated_feed_item.attributes = params[:curated_feed_item]

    if @curated_feed_item.save
      redirect_to(admin_curated_feed_item_path(@curated_feed, @curated_feed_item), :notice => 'Feed item was successfully updated.')
    else
      render "edit"
    end
  end

  # DELETE /admin/curated_feeds/1/items/1
  def destroy
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_item = CuratedFeedItem.find(params[:id])
    @curated_feed_item.destroy
    redirect_to(admin_curated_feed_items_path(@curated_feed))
  end
end
