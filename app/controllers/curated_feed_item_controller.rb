class CuratedFeedItemController < ApplicationController
  layout false

  # Retrieve curated feed and related entries to create RSS feed
  def curated_feed
    @curated_feed = CuratedFeed.find(params[:curated_feed_id])
    @curated_feed_items = CuratedFeedItem.where(:curated_feed_id => params[:curated_feed_id])
  end

end
