class SettingsPage < PageObject
  def click_unlink_from_facebook
    @page.click_link_or_button "Unlink from Facebook"
  end

  def visit(user)
    @page.visit edit_user_path(user)
  end
end
