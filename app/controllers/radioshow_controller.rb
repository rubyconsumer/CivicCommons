class RadioshowController < ApplicationController
  def show
    @radio_show = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @radio_shows = ContentItem.where("content_type = 'RadioShow' AND (published <= curdate() OR DAY(published) = DAY(curdate())) ").order("published desc");
  end
end
