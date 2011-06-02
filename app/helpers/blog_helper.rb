module BlogHelper

  def format_publish_date(date)
    date = date.published if date.is_a? ContentItem
    return date.strftime('%A, %B %d, %Y')
  end
end
