class UserEditProfilePage < PageObject

  def visit_user(user)
    visit edit_user_path(user)
  end
  
  def click_submit
    page.click_link_or_button 'Update Settings'
  end
end
