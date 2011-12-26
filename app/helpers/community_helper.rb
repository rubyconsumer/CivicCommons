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

  def display_name(entity)
    entity.last_name.blank? || entity.first_name.blank? ? entity.name : "#{entity.last_name}, #{entity.first_name}"
  end
end
