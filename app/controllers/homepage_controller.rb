class HomepageController < ApplicationController
  def show
    @most_visited_conversations = Conversation.get_top_visited(3)
    @random_active_conversation = Conversation.random_active(3)
    @random_recommended_conversation = Conversation.random_recommended.first
    @random_issues = Issue.all.sample(3)
    @random_most_recent_conversations = Conversation.latest_created.limit(4).sample(4)
    @staff_selected = HomepageFeatured.min_sample(3, [@most_visited_conversations, @random_active_conversation, @random_recommended_conversation, @random_issues, @random_most_recent_conversations])

    @conversations = Conversation.latest_created.paginate(:page => params[:page], :per_page => 6)

    @recent_blog_posts = ContentItem.recent_blog_posts.limit(1)
    @recent_radio_shows = ContentItem.recent_radio_shows.limit(1)
    @regions = Region.all

    @recent_items = Activity.most_recent_activity(3).collect{|a| a.item}

    respond_to do |format|
      format.html
    end
  end
end
