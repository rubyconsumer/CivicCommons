class PollsController < ApplicationController
  layout nil
  
  def index
    poll_response = HTTParty.get("#{Civiccommons::PeopleAggregator.URL}/poll_module.php?authToken=#{params[:authToken]}&silent=#{params[:silent]}".tap{|u| logger.debug u.inspect})
    render :text => poll_response.body
  end

  def create
    poll_post = HTTParty.post("#{Civiccommons::PeopleAggregator.URL}/save_vote.php?authToken=#{params[:authToken]}&silent=#{params[:silent]}", :body => params)
    render :text => poll_post.body
  end
end
