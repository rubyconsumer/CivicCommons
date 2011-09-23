class Admin::FeaturedHomepageController < Admin::DashboardController
  def index
    conversations = Conversation.includes(:homepage_featured).latest_created
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
    item = params[:type].constantize.find(params[:id])
    if params[:featured]
      item.homepage_featured = HomepageFeatured.create unless item.featured?
    else
      item.homepage_featured.destroy if item.featured?
    end
    item.reload
    flash[:notice] = "Successfully updated #{ params[:type] } #{ params[:id] } to #{ item.featured?.to_s }."

    respond_to do |format|
      format.html { redirect_to admin_featured_homepage_index_path }
    end
  end
end