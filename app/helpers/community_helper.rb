module CommunityHelper
  
  def community_site_filter_link(order)
    case order
    when 'newest-member'
      title = 'Newest Members'
    end
    
    link_to title, 
      community_path(:order => (@order == order ? nil : order), :page => params[:page]), 
      :id => order, 
      :class => (@order == order ? 'active' : nil )
  end
end