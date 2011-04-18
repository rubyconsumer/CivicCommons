class ContentItemsController < ApplicationController

  # GET /content_items/1
  def show
    @conversation = Conversation.includes(:issues).find(params[:id])
    @conversation.visit!((current_person.nil? ? nil : current_person.id))
    @contributions = Contribution.for_conversation(@conversation)
    render :show
  end

  # GET /blog
  def blog_index
    @blog_posts = ContentItem.find_all_by_content_type(:BlogPost);
  end
end
