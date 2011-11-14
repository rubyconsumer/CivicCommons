module CommunityHelper
  def community_site_filter_link(order)
    case order
    when 'alphabetical'
      title = 'Alphabetical'
    when 'newest-member'
      title = 'Newest Members'
    when 'active-member'
      title = 'Most Active'
    end

    link_to title, 
      community_path(:order => (@order == order ? nil : order), :page => params[:page]), 
      :id => order, 
      :class => (@order == order ? 'active' : nil )
  end
end
