class CommunityController < ApplicationController

  def index
    @people = Person.paginate(:page => params[:page], :per_page => 16)
    @regions = Region.all
  end

end