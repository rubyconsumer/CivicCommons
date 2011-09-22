class VoteConfirmationPage < PageObject
  TITLE = 'You are about to submit your voting selections'
  def click_yes
    page.click_link_or_button('Yes')
  end
  
  

end
