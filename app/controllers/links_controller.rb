class LinksController < ApplicationController 
  before_filter :remember_url, :require_user 

  def new 
    @issues = Issue.alphabetical
    @conversations = Conversation.all
    @contribution = Contribution.new
    @contribution.url = link
    @contribution.type = "Link"
  end

  def create
    @link = Contribution.new params[:contribution]  
    @link.save
    redirect_to "/"
  end

  private
  def remember_url 
    session[:link] = params[:link] unless params[:link].nil?
  end

  def link 
    session[:link] || params[:link]
  end
end
