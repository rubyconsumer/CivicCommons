class Admin::ContentItemsController < Admin::DashboardController

  #GET admin/content_items
  def index
    @content_items = ContentItem.all
  end
end
