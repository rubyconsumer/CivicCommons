class CommunityController < ApplicationController

  def index
    ordered_people
    @regions = Region.all
    @recent_items = Activity.most_recent_activity(3)
  end


  private

  def ordered_people
    if params[:order] == 'recent'
      @people = Person.find_confirmed_order_by_recency.paginate(:page => params[:page], :per_page => 16)
    elsif params[:order] == 'alpha'
      @people = Person.find_confirmed_order_by_last_name(params[:letter]).paginate(:page => params[:page], :per_page => 16)
    else
      @people = Person.find_confirmed_order_by_last_name.paginate(:page => params[:page], :per_page => 16)
    end
  end

end
