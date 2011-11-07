class SuggestFacebookAuthPage < PageObject
  
  def path
    '/authentication/decline_fb_auth'
  end
  
  def click_decline
    Capybara.current_session.driver.post path
  end
  
  def modal
    %q[$.colorbox({opacity:0.5, html:'<div class=\"suggest-auth facebook-auth fb-modal\"]
  end
  
  def title
    'Have a Facebook account?'
  end
  
end
