require File.expand_path(File.dirname(__FILE__) + '/page_object')
class AdminSurveyProgressPage < PageObject
  
  def visit_progress_page(survey)
    @page.visit progress_admin_survey_path(user)
  end

end
