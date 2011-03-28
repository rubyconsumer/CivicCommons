require File.expand_path(File.dirname(__FILE__) + '/page_object')

class AdminContentItemsPage < PageObject

  def table_contains?(content_item)
    if page.find('table td').find(text: content_item.title)
      return true
    else
      false
    end
  end

end
