class LinksController < ApplicationController
  before_filter :remember_url, :require_user

  def new
    @issues = Issue.alphabetical
    @conversations = Conversation.all
    @contribution = Contribution.new
    @contribution.url = link
    @contribution.title = title
    forget_url
  end

  def create
    @link = Contribution.new params[:contribution]
    @link.save
    redirect_to "/"
  end

  private

  def remember_url
    return if params[:link].nil?
    session[:link] = params[:link]
    session[:title] = params[:title]
  end

  def forget_url
    session[:link] = nil
  end

  def title
    session[:title] || params[:title]
  end

  def link
    session[:link] || params[:link]
  end
end
