class SuccessfulFbRegistrationPage < PageObject
  
  def path
    '/authentication/successful_fb_registration'
  end
  
  def click_submit
    page.click_button 'person_submit'
  end
  
  def fill_in_zip_code_with(zip)
    page.fill_in 'person_zip_code', :with => zip
  end
  
end