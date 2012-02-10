module BlogHelper

  def format_publish_date(date)
    date = date.published if date.is_a? ContentItem
    return date.strftime('%A, %B %d, %Y')
  end
  
  def blog_filter_by_author_link(author,current_author)
    link_to raw("#{profile_image(author,16,  'mem-img')}<span>#{author.name}</span>"), blog_index_path(:author_id => author.id), :class => "#{'active' if current_author.try(:id) == author.id}"
  end
end
