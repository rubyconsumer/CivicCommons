class CommunityController < ApplicationController

  def index
    ordered_people
    @regions = Region.all
    @recent_items = Activity.most_recent_activity(3)
  end


  private

  def ordered_people
    @order = params[:order] || 'newest-member'
    case @order
    when 'alphabetical'
      @subtitle = 'Alphabetical'
      @people = Person.find_confirmed_order_by_last_name(params[:letter]).paginate(:page => params[:page], :per_page => 16)
    else
      @subtitle = 'Newest Members'
      @people = Person.find_confirmed_order_by_recency.paginate(:page => params[:page], :per_page => 16)
    end
  end

end
