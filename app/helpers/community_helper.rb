module CommunityHelper
  def community_site_filter_link(order)
    case order
    when 'alphabetical'
      title = 'Alphabetical'
    when 'newest-member'
      title = 'Newest Members'
    when 'active-member'
      title = 'Most Active'
    when 'organizations'
      title = 'Organizations'
    when 'people'
      title = 'People'
    end
    merged_params =  request.parameters.merge({:order => (@order == order ? nil : order), :page => params[:page]})
    css_class = @order == order ? 'active' : nil 
    
    link_to title, community_path(merged_params), :id => order, :class => css_class 
  end
  
  def community_site_people_filter_link(filter)
    active = @current_filter == filter
    css_class = active ? 'active' : ''
    case filter
    when 'people'
      filter_name = 'People Only'
    when 'organizations'
      filter_name = 'Organizations Only'
    else
      filter_name = 'People & Organizations'
    end
    
    link_to raw("<span>#{filter_name}</span>"), community_path(request.parameters.merge({:filter => filter, :page=>nil})), :class=> css_class
  end
  

  def display_name(entity)
    entity.last_name.blank? || entity.first_name.blank? ? entity.name : "#{entity.last_name}, #{entity.first_name}"
  end
end
