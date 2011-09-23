class Admin::FeaturedHomepageController < Admin::DashboardController
  def index
    conversations = Conversation.latest_created
    @items = []
    @items |= conversations.collect do |conversation|
      {
        created_at: conversation.created_at,
        featured: conversation.featured?,
        id: conversation.id,
        title: conversation.title,
        type: conversation.class.to_s
      }
    end
  end

  def update
    flash[:notice] = "Successfully updated #{ params[:type] } #{ params[:id] }."
    redirect_to admin_featured_homepage_index_path
  end
end