class Admin::FeaturedHomepageController < Admin::DashboardController
  def index
    @items = []

    conversations = Conversation.includes(:homepage_featured).latest_created
    @items |= conversations.collect do |conversation|
      {
        created_at: conversation.created_at,
        featured: conversation.featured?,
        id: conversation.id,
        title: conversation.title,
        type: conversation.class.to_s
      }
    end

    issues = Issue.includes(:homepage_featured).most_recent
    @items |= issues.collect do |issue|
      {
        created_at: issue.created_at,
        featured: issue.featured?,
        id: issue.id,
        title: issue.name,
        type: issue.class.to_s
      }
    end
  end

  def update
    item = params[:type].constantize.find(params[:id])
    if params[:featured]
      item.homepage_featured = HomepageFeatured.create unless item.featured?
    else
      item.homepage_featured.destroy if item.featured?
    end
    flash[:notice] = "Successfully updated #{ params[:type] } #{ params[:id] } to #{ (!params[:featured].nil?).to_s }."

    respond_to do |format|
      format.html { redirect_to admin_featured_homepage_index_path }
    end
  end
end