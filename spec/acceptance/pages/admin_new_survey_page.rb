require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminNewSurveyPage < PageObject

  def path
    '/admin/surveys/new'
  end
  
  def click_create_survey
    @page.click_link_or_button 'Create Survey'
  end
  
  def fill_in_survey_fields
    @page.fill_in(:title, :with => 'Title here')
    @page.select_date('end_date', :with => 1.week.from_now.to_date.to_s)
  end
  
end