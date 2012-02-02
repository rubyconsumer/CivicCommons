class BlogController < ApplicationController

  # GET /blog/1
  def show
    @blog_post = ContentItem.find(params[:id])
    setup_meta_info(@blog_post)
  end

  # GET /blog
  def index
    @blogpost_description = ContentItemDescription.blog_post.first
    respond_to do |format|
      format.xml { @blog_posts = ContentItem.recent_blog_posts.limit(25) }
      format.html { @blog_posts = ContentItem.recent_blog_posts.paginate(:page => params[:page], :per_page => 5) }
    end
  end

end
