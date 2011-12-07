require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Register Feature", %q{
  As an anonymous person
  I want to sign up for an account
  So that I can interact with The Civic Commons community
} do

  background do
    # clean up
    database.delete_all_person
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
    email, subject = mask_with_intercept_email(person[:email], 'Confirmation instructions')
    should_send_an_email({
      'To' => email,
      'Subject' => subject
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
  
  context "principles" do
    scenario "Visitor sees principle before signing up as a user", :js => true do
      goto :home
      follow_account_registration_link
      should_be_on registrations_principles_path
    end
    scenario "When a visitor accepts the principle, they can continue on to the registration page", :js => true do
      goto :registration_principles
      check_agree
      follow_continue_as_person_link
      should_be_on new_person_registration_path
    end
    scenario "When a visitor did not accept the principle, they cannot continue on to the registration page", :js => true do
      goto :registration_principles
      follow_continue_as_person_link
      should_not_be_on new_person_registration_path
      should_be_on registrations_principles_path
      current_page.should have_an_error_for :must_agree_to_principles
    end
  end
end
