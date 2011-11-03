require File.expand_path(File.dirname(__FILE__) + '/page_object')

class SearchResultsPage < PageObject

  def path
    '/search/results'
  end

  def has_filter_selected?(filter)
    if filter == 'Conversations'
      selector = 'li a#conv-s.active'
    elsif filter == 'Issues'
      selector = 'li a#issues-s.active'
    elsif filter == 'Community'
      selector = 'li a#comm-s.active'
    end
    @page.has_selector?(selector, :content => filter) if defined?(selector)
  end
end
