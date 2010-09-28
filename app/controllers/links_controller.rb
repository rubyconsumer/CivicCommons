class LinksController < ApplicationController 
  before_filter :require_user 

  def new 
    @link = Link.new
  end

end
