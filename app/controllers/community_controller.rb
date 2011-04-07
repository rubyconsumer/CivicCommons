class CommunityController < ApplicationController

  def index
    ordered_people
    @regions = Region.all
    @recent_items = TopItem.newest_items(3).with_items_and_associations.collect(&:item)
  end


  private
  
  def ordered_people
    if params[:order] == 'recent'
      order_by = 'confirmed_at DESC'
    else
      order_by = 'first_name ASC'
    end
    @people = Person.order(order_by).where('confirmed_at IS NOT NULL').paginate(:page => params[:page], :per_page => 16)
  end

end
