class RadioshowController < ApplicationController

  # GET /radioshow/1
  def show
    @radioshow_description = ContentItemDescription.radio_show.first

    @radioshow = ContentItem.find(params[:id])
    setup_meta_info(@radioshow)
  end

  # GET /radioshow
  def index
    @radioshow_description = ContentItemDescription.radio_show.first

    @topics = Topic.including_public_radioshows
    @current_topic = Topic.find_by_id(params[:topic])
    search = @current_topic ? @current_topic.radioshows : ContentItem.radio_show
    @radioshows = search.where('published <= curdate() OR DAY(published) = DAY(curdate())').order("published desc")

    respond_to do |format|
      format.xml { @radioshows = @radioshows.limit(25) }
      format.html do
        @radioshows = @radioshows.paginate(:page => params[:page], :per_page => 5)
        @recent_blog_posts = ContentItem.recent_blog_posts.limit(3)
      end
    end
  end

  # GET /podcast
  def podcast
    @radioshows = ContentItem.radio_show('published <= curdate() OR DAY(published) = DAY(curdate())').order("published desc")
  end
end
