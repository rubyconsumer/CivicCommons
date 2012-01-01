class CommunityController < ApplicationController

  def index
    ordered_people
    filtered_people
    paginated_people
    @regions = Region.all
  end


  private
  
  def filtered_people
    @current_filter = params[:filter] || 'all'
    case @current_filter
    when 'all'
      @community 
    when 'people'
      @community = @community.only_people
    when 'organizations'
      @community = @community.only_organizations
    end
  end
  
  def ordered_people
    @order = params[:order] || 'newest-member'
    case @order
    when 'alphabetical'
      @subtitle = 'Alphabetical'
      @community = Person.find_confirmed_order_by_last_name(params[:letter])
    when 'active-member'
      @subtitle = 'Most Active'
      @community = Person.find_confirmed_order_by_most_active()
    else
      @subtitle = 'Newest Members'
      @community = Person.find_confirmed_order_by_recency
    end
  end
  
  def paginated_people
    @community = @community.paginate(:page => params[:page], :per_page => 16)
  end

end
