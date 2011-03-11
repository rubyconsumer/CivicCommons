require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

require 'pp'

feature "Register Feature", %q{
  As an anonymous person
  I want to sign up for an account
  So that I can interact with the Civic Commons community
} do

  background do
    # clean up
    Person.delete_all
    clear_mail_queue
  end

  scenario "User signs up for account with valid credentials" do

    # Given I am on the registration page
    reg_page = RegistrationPage.new(page)
    reg_page.visit

    # And I sign up with valid credentials
    person = Factory.attributes_for(:normal_person)
    reg_page.fill_registration_form_and_submit(person)

    # Then a user should be created with my credentials
    Person.where(email: person[:email]).count.should == 1

    # And a confirmation email should be sent
    should_send_an_email({
      'To' => person[:email],
      'Subject' => 'Confirmation instructions'
    })

  end

  scenario "User signs up for account with invalid credentials" do

    # Given I am on the registration page
    reg_page = RegistrationPage.new(page)
    reg_page.visit

    # And I sign up with invalid credentials
    person = Factory.attributes_for(:invalid_person)
    reg_page.fill_registration_form_and_submit(person)

    # Then a user should not be created with my credentials
    Person.where(email: person[:email]).count.should == 0

    # And a confirmation email should be not sent
    should_not_send_an_email

  end

end
