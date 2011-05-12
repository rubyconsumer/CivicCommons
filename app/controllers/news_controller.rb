class NewsController < ApplicationController

  # GET /news
  def index
    respond_to do |format|
      format.xml { @news_items = ContentItem.where("content_type = 'NewsItem' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").limit(25) }
      format.html { @news_items = ContentItem.where("content_type = 'NewsItem' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").paginate(:page => params[:page], :per_page => 5) }
    end
  end

end
