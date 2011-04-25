class BlogController < ApplicationController
  def show
    @blog_post = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @blog_posts = ContentItem.find_all_by_content_type("BlogPost");
  end
end
