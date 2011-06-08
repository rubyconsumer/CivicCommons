class Admin::CuratedFeedItemsController < ApplicationController
  # GET /admin/curated_feed_items
  # GET /admin/curated_feed_items.xml
  def index
    @admin_curated_feed_items = Admin::CuratedFeedItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_curated_feed_items }
    end
  end

  # GET /admin/curated_feed_items/1
  # GET /admin/curated_feed_items/1.xml
  def show
    @admin_curated_feed_item = Admin::CuratedFeedItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_curated_feed_item }
    end
  end

  # GET /admin/curated_feed_items/new
  # GET /admin/curated_feed_items/new.xml
  def new
    @admin_curated_feed_item = Admin::CuratedFeedItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_curated_feed_item }
    end
  end

  # GET /admin/curated_feed_items/1/edit
  def edit
    @admin_curated_feed_item = Admin::CuratedFeedItem.find(params[:id])
  end

  # POST /admin/curated_feed_items
  # POST /admin/curated_feed_items.xml
  def create
    @admin_curated_feed_item = Admin::CuratedFeedItem.new(params[:admin_curated_feed_item])

    respond_to do |format|
      if @admin_curated_feed_item.save
        format.html { redirect_to(@admin_curated_feed_item, :notice => 'Curated feed item was successfully created.') }
        format.xml  { render :xml => @admin_curated_feed_item, :status => :created, :location => @admin_curated_feed_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_curated_feed_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/curated_feed_items/1
  # PUT /admin/curated_feed_items/1.xml
  def update
    @admin_curated_feed_item = Admin::CuratedFeedItem.find(params[:id])

    respond_to do |format|
      if @admin_curated_feed_item.update_attributes(params[:admin_curated_feed_item])
        format.html { redirect_to(@admin_curated_feed_item, :notice => 'Curated feed item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_curated_feed_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/curated_feed_items/1
  # DELETE /admin/curated_feed_items/1.xml
  def destroy
    @admin_curated_feed_item = Admin::CuratedFeedItem.find(params[:id])
    @admin_curated_feed_item.destroy

    respond_to do |format|
      format.html { redirect_to(admin_curated_feed_items_url) }
      format.xml  { head :ok }
    end
  end
end
