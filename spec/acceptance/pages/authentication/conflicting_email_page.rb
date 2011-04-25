class ConflictingEmailPage < PageObject
  
  def path
    '/authentication/conflicting_email'
  end
  
  def click_yes
    yes_link = page.find('a.overwrite-email')['href']
    # this is because, we use javascript to do a POST to this url
    Capybara.current_session.driver.process :post, yes_link
  end
  
end