class NewsController < ApplicationController
  def show
    @news_item = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @news_items = ContentItem.find_all_by_content_type("NewsItem");
  end
end
