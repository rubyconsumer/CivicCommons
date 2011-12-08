require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Register Feature", %q{
  As an anonymous person
  I want to sign up for an account
  So that I can interact with The Civic Commons community
} do

  include Facebookable

  background do
    clear_mail_queue
  end

  scenario "User signs up without facebook" do
    pending
    goto :registration_page
    fill_in_bio_with "Im a hoopy frood!"
    fill_in_zip_code_with "47134"
    uncheck_weekly_newsletter_checkbox

    follow_i_dont_want_to_use_facebook_link
    zip_code_field.should have_value "47134"
    bio_field.should have_value "47134"
    weekly_newsletter_checkbox.should_not be_checked
    daily_digest_checkbox.should be_checked

    #The actual assertion stuff should be part of card #311
  end

  scenario "User signs up with facebook" do
    goto :registration_page
    fill_in_bio_with "Im a hoopy frood!"
    fill_in_zip_code_with "47134"
    follow_connect_with_facebook_link

    current_page.should be_for :thanks_go_check_your_email
    newly_registered_user.should have_been_sent :registration_confirmation_email
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
