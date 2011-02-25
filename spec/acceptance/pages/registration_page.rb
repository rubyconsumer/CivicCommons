class RegistrationPage

  def initialize(page)
    @page = page 
  end

  def visit
    @page.visit '/people/register/new'
  end

  def fill_registration_form_and_submit(person)
    @page.fill_in 'person[name]', with: person[:first_name] + " " + person[:last_name]
    @page.fill_in 'person[email]', with: person[:email]
    @page.fill_in 'person[zip_code]', with: person[:zip_code]
    @page.fill_in 'person[password]', with: person[:password]
    @page.fill_in 'person[password_confirmation]', with: person[:password]
    #@page.attach_file("person[avatar]", File.join(attachments_path, 'imageAttachment.png'))

    @page.click_button 'Continue'
  end

end
