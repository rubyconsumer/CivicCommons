class NewsController < ApplicationController
  def show
    @news_item = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @news_items = ContentItem.where("content_type = 'NewsItem' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").paginate(:page => params[:page], :per_page => 10)
  end
end
