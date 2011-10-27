require File.expand_path(File.dirname(__FILE__) + '/page_object')

class SearchResultsPage < PageObject
  
  def path
    '/search/results'
  end
end