require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminTopicsPage < PageObject

  def path
    '/admin/topics'
  end
  
  def click_new_topic
    @page.click_link 'Add Topic'
  end

  
  def click_edit_on_a_topic(topic)
    locator = "//a[contains(text(),'Edit')][contains(@href,'#{edit_admin_topic_path(topic.id)}')]"
    msg = "no link with title, id or text '#{locator}' found"
    @page.find(:xpath, locator, :message => msg).click
    # @page.click_link "//a[contains(text(),'Edit')][contains(@href,'#{edit_admin_survey_path(survey.id)}')]"
  end
end

