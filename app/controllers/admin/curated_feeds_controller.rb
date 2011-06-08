class Admin::CuratedFeedsController < ApplicationController
  # GET /admin/curated_feeds
  # GET /admin/curated_feeds.xml
  def index
    @admin_curated_feeds = Admin::CuratedFeed.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_curated_feeds }
    end
  end

  # GET /admin/curated_feeds/1
  # GET /admin/curated_feeds/1.xml
  def show
    @admin_curated_feed = Admin::CuratedFeed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_curated_feed }
    end
  end

  # GET /admin/curated_feeds/new
  # GET /admin/curated_feeds/new.xml
  def new
    @admin_curated_feed = Admin::CuratedFeed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_curated_feed }
    end
  end

  # GET /admin/curated_feeds/1/edit
  def edit
    @admin_curated_feed = Admin::CuratedFeed.find(params[:id])
  end

  # POST /admin/curated_feeds
  # POST /admin/curated_feeds.xml
  def create
    @admin_curated_feed = Admin::CuratedFeed.new(params[:admin_curated_feed])

    respond_to do |format|
      if @admin_curated_feed.save
        format.html { redirect_to(@admin_curated_feed, :notice => 'Curated feed was successfully created.') }
        format.xml  { render :xml => @admin_curated_feed, :status => :created, :location => @admin_curated_feed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_curated_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/curated_feeds/1
  # PUT /admin/curated_feeds/1.xml
  def update
    @admin_curated_feed = Admin::CuratedFeed.find(params[:id])

    respond_to do |format|
      if @admin_curated_feed.update_attributes(params[:admin_curated_feed])
        format.html { redirect_to(@admin_curated_feed, :notice => 'Curated feed was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_curated_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/curated_feeds/1
  # DELETE /admin/curated_feeds/1.xml
  def destroy
    @admin_curated_feed = Admin::CuratedFeed.find(params[:id])
    @admin_curated_feed.destroy

    respond_to do |format|
      format.html { redirect_to(admin_curated_feeds_url) }
      format.xml  { head :ok }
    end
  end
end
