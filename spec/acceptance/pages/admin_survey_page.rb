class AdminSurveyPage < PageObject

  def path
    '/admin/surveys'
  end
  
  def visit_new_surveys(user)
    @page.visit edit_user_path(user)
  end

end
