require 'issue'

class RegionsController < ApplicationController

  def index
    @regions = Region.all
  end

  def show
    @region = params[:id] == "default" ? Region.default : Region.find(params[:id])
    @regions = Region.all
    @conversations = @region.conversations
  end

end
