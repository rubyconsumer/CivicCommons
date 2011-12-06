class HomepageController < ApplicationController
  def show
    @random_issues = Issue.all.sample(2)

    @random_most_recent_conversations = Conversation.latest_created.limit(4).sample(4)
    @random_recommended_conversation = Conversation.random_recommended(1, [@random_most_recent_conversations]).first
    @random_active_conversation = Conversation.random_active(1, 4, [@random_most_recent_conversations, @random_recommended_conversation])
    @staff_selected = HomepageFeatured.sample_and_filtered(3, [@random_active_conversation, @random_recommended_conversation, @random_issues, @random_most_recent_conversations])

    @conversations = Conversation.latest_created.paginate(:page => params[:page], :per_page => 6)

    @recent_blog_posts = ContentItem.recent_blog_posts.limit(1)
    @recent_radio_shows = ContentItem.recent_radio_shows.limit(1)
    @regions = Region.all

    @recent_items = Activity.most_recent_activity_items(3)

    respond_to do |format|
      format.html
    end
  end
end
