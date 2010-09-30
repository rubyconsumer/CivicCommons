class LinksController < ApplicationController 
  before_filter :remember_url, :require_user 

  def new 
    @issues = Issue.alphabetical
    @conversations = Conversation.all
    @link = Link.new
    @link.url = link
  end

  def create
    @link = Link.new params[:link]  
    @link.save
    redirect_to "/"
  end

  private
  def remember_url 
    session[:link] = params[:link]
  end

  def link 
    session[:link] || params[:link]
  end
end
