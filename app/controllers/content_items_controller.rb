class ContentItemsController < ApplicationController

  # GET /content_items/1
  def blog_show
    @blog_post = ContentItem.find(params[:id])
  end

  # GET /blog
  def blog_index
    @blog_posts = ContentItem.find_all_by_content_type(:BlogPost);
  end
end
