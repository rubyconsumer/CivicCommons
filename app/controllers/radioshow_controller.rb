class RadioshowController < ApplicationController

  # GET /radioshow/1
  def show
    @radioshow = ContentItem.find(params[:id])
  end

  # GET /radioshow
  def index
    @radioshows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").paginate(:page => params[:page], :per_page => 5)
  end

  # GET /podcast
  def podcast
    @radioshows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc").paginate(:page => params[:page], :per_page => 5)
  end
end

