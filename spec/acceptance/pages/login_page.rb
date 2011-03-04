# http://www.cheezyworld.com/2010/11/09/ui-tests-not-brittle/
class LoginPage

  def initialize(page)
    @page = page 
  end

  def sign_in(person)
    #@page.visit new_person_page_path(person)
    @page.visit '/people/login' 
    @page.fill_in('Email', :with => person.email)
    @page.fill_in('Password', :with => person.password)
    @page.click_on('Login')
  end

  def sign_out()
    #@page.visit destroy_person_session_path
    @page.visit '/people/logout'
  end

end
