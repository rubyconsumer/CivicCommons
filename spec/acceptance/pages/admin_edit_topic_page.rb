require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminEditTopicPage < PageObject
  
  def click_update_topic
    @page.click_link_or_button 'Update Topic'
  end
  
  def fill_in_topic_fields(options={})
    @page.fill_in(:name, :with => options[:name]) if options.has_key?(:name)
  end
  
end