class ContentController < ApplicationController
  def show
    @content_item = ContentItem.find(params[:id])
  end

  def index
    @content_items = ContentItem.find_all_by_content_type("Untyped");
  end
end
