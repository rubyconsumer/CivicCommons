class UserProfilePage < PageObject

  def visit_user(user)
    visit user_path(user)
  end

end
