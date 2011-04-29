class BlogController < ApplicationController
  def show
    @blog_post = ContentItem.find(params[:id])
  end

  # GET /blog
  def index
    @blog_posts = ContentItem.where("content_type = 'BlogPost' AND (published <= curdate() OR DAY(published) = DAY(curdate()))");
  end
end
