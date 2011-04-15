class BeforeFacebookUnlinkingPage < PageObject
  
  def path
    '/authentication/before_facebook_unlinking'
  end
  
  def click_yes
    page.click_link('Yes')
  end
  
end