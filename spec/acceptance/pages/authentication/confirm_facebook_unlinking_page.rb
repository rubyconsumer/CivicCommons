class ConfirmFacebookUnlinkingPage < PageObject
  
  def path
    '/authentication/confirm_facebook_unlinking'
  end
  
  def click_yes
    page.click_link('Yes')
  end
  
end