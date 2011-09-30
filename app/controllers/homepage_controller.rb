class HomepageController < ApplicationController
  def show
    @most_visited_conversations = Conversation.get_top_visited(3)
    @random_active_conversation = Conversation.random_active(3)
    @random_recommended_conversation = Conversation.random_recommended.first
    @random_issues = Issue.all.sample(3)
    @random_most_recent_conversations = Conversation.latest_created.limit(4).sample(4)
    @staff_selected = HomepageFeatured.min_sample(3, [@most_visited_conversations, @random_active_conversation, @random_recommended_conversation, @random_issues, @random_most_recent_conversations])

    @conversations = Conversation.latest_created.paginate(:page => params[:page], :per_page => 6)

    @blog_posts = ContentItem.recent_blog_posts.first
    @random_old_radio_show = ContentItem.random_old_radio_show
    @regions = Region.all

    @recent_items = Activity.most_recent_activity(3)
  end
end
