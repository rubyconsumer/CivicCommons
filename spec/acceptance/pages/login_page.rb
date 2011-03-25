require File.expand_path(File.dirname(__FILE__) + '/page_object')

class LoginPage < PageObject

  def sign_in(person)
    sign_out
    @page.visit '/people/login' 
    @page.fill_in('Email', :with => person.email)
    @page.fill_in('Password', :with => person.password)
    @page.click_on('Login')
    @page
  end

  def sign_out()
    @page.visit '/people/logout'
    @page
  end

end
