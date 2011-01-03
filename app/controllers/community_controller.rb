class CommunityController < ApplicationController

  def index
    @people = Person.where('confirmed_at IS NOT NULL').paginate(:page => params[:page], :per_page => 16)
    @regions = Region.all
  end

end