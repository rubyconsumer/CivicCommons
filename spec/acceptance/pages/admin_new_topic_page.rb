require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminNewTopicPage < PageObject

  def path
    '/admin/topics/new'
  end
  
  def click_create_topic
    @page.click_link_or_button 'Create Topic'
  end
  
  def fill_in_topic_fields
    @page.fill_in(:name, :with => 'Topic here')
  end
  
end