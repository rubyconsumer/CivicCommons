class RadioshowController < ApplicationController

  # GET /radioshow/1
  def show
    @radioshow = ContentItem.find(params[:id])
    setup_meta_info(@radioshow)
  end

  # GET /radioshow
  def index
    respond_to do |format|
      format.xml { @radioshows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").limit(25) }
      format.html do 
        @radioshows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").paginate(:page => params[:page], :per_page => 5) 
        @recent_blog_posts = ContentItem.recent_blog_posts.limit(3)
      end
    end
  end

  # GET /podcast
  def podcast
    @radioshows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc")
  end
end

