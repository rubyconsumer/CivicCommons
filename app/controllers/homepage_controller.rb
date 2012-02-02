class HomepageController < ApplicationController
  def show
    build_featured_items_section

    @regions = Region.all

    @conversations = Conversation.latest_created.paginate(:page => params[:page], :per_page => 6)
    @recent_items = Activity.most_recent_activity_items(3)

    respond_to do |format|
      format.html
    end
  end

  # Build Featured Items Section so Featured Items do not repeat.
  #
  # We build up a filter object to keep track of which Conversation and/or Issue is being used.
  #
  # HomepageFeatured object is made up of different objects types so it's important to build the filter appropriately.
  def build_featured_items_section
    filters = []
    filters << @random_most_recent_conversations = Conversation.latest_created.limit(4).sample(4)
    filters << @random_recommended_conversation = Conversation.random_recommended(1, filters).first
    filters << @random_active_conversation = Conversation.random_active(1, 4, filters)
    filters << @random_issues = Issue.all.sample(2)
    filters << @staff_selected = HomepageFeatured.sample_and_filtered(3, filters)

    @recent_blog_posts = ContentItem.recent_blog_posts.limit(1)
    @recent_radio_shows = ContentItem.recent_radio_shows.limit(1)
  end
end
