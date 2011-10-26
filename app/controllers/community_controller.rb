class CommunityController < ApplicationController

  def index
    ordered_people
    @regions = Region.all
    @recent_items = Activity.most_recent_activity(3)
  end


  private

  def ordered_people
    @order = params[:order]
    case @order
    when 'newest-member'
      @subtitle = 'Newest Members'
      @people = Person.confirmed_accounts.sort_latest_created_at.paginate(:page => params[:page], :per_page => 16)
    when 'alpha'
      @people = Person.find_confirmed_order_by_last_name(params[:letter]).paginate(:page => params[:page], :per_page => 16)
    when 'recent'
      @people = Person.find_confirmed_order_by_recency.paginate(:page => params[:page], :per_page => 16)
    else
      @people = Person.find_confirmed_order_by_last_name.paginate(:page => params[:page], :per_page => 16)
    end
  end

end
