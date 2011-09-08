require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminSurveysPage < PageObject

  def path
    '/admin/surveys'
  end
  
  def click_new_survey
    @page.click_link 'New Survey'
  end
  
  def click_edit_on_a_survey(survey)
    locator = "//a[contains(text(),'Edit')][contains(@href,'#{edit_admin_survey_path(survey.id)}')]"
    msg = "no link with title, id or text '#{locator}' found"
    @page.find(:xpath, locator, :message => msg).click
    # @page.click_link "//a[contains(text(),'Edit')][contains(@href,'#{edit_admin_survey_path(survey.id)}')]"
  end

end
