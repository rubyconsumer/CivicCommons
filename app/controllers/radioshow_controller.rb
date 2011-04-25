class RadioshowController < ApplicationController
  def show
    @radio_show = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @radio_shows = ContentItem.find_all_by_content_type("RadioShow");
  end
end
