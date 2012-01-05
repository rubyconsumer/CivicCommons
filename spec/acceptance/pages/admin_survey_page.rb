class AdminSurveyPage < PageObject

  def path
    '/admin/surveys'
  end
  
  def visit_new_surveys(user)
    @page.visit secure_edit_user_url(user)
  end

end
