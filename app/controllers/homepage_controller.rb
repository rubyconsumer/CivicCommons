class HomepageController < ApplicationController

  def show
    @most_recent_conversation  = Conversation.latest_created.limit(1)
    @most_active_conversation  = Conversation.most_active(filter:@most_recent_conversation).limit(1)
    @most_popular_conversation = Conversation.get_top_visited(filter:[@most_recent_conversation, @most_active_conversation], limit:1)

    @featured_opportunities = FeaturedOpportunity.all

    @recent_items = Activity.most_recent_activity_items(limit: 30)
    @recent_blog_post = ContentItem.recent_blog_posts.first

    respond_to do |format|
      format.html
    end
  end

end
