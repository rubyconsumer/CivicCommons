require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Register Feature", %q{
  As an anonymous person
  I want to sign up for an account
  So that I can interact with The Civic Commons community
} do

  include Facebookable

  background do
    database.delete_all_person
    stub_facebook_auth
    clear_mail_queue
  end

  scenario "User signs up without facebook", :js => true do
    goto :registration_page
    fill_in_bio_with "Im a hoopy frood!"
    fill_in_zip_code_with "47134"
    uncheck_weekly_newsletter

    follow_i_dont_want_to_use_facebook_link

    zip_code_field.should have_value "47134"
    bio_field.should have_value "Im a hoopy frood!"
    weekly_newsletter_checkbox.should_not be_checked
    daily_digest_checkbox.should be_checked

    fill_in_first_name_with'John'
    fill_in_last_name_with 'Doe'
    fill_in_email_with 'johndoe@test.com'
    fill_in_password_with 'passwordhere123'
    fill_in_password_confirmation_with 'passwordhere123'

    click_continue_button
    should_be_on root_path
  end

  scenario "User signs up without facebook and with invalid information", :js => true do
    goto :registration_page
    follow_i_dont_want_to_use_facebook_link
    click_continue_with_invalid_information_button
    current_page.should have_an_error_for :invalid_name
    current_page.should have_an_error_for :invalid_email

    # TODO as part of ticket 309 - password needs to be validated on non-facebook signup.
    # current_page.should have_an_error_for :invalid_password
  end

  scenario "User signs up with facebook", :js=>true do
    pending
    goto :registration_page
    fill_in_bio_with "Im a hoopy frood!"
    fill_in_zip_code_with "47134"
    follow_connect_with_facebook_link

    wait_until { Person.last }

    newly_registered_user.bio.should == "Im a hoopy frood!"
    newly_registered_user.zip_code.should == "47134"
    newly_registered_user.should have_been_sent :registration_confirmation_email

    current_page.should be_for :thanks_for_registering
  end
  describe 'signing up as an organization' do
    def begin_registering_as_organization
      goto :registration_principles
      agree_to_terms
      follow_continue_as_organization_link
      fill_in_organization_details_with organization_details
    end
    def organization_details
      {
        name: 'Crute Farms',
        email: 'dwight@example.com',
        password: 'dwightisyoursavior',
        password_confirmation: 'dwightisyoursavior',
        logo: 'imageAttachment.png',
        description: "i raise beets with my cousin mose. You may use it as a bed and breakfast",
        zip_code: '18512'
      }
    end
    scenario "when I have the authority" do
      begin_registering_as_organization
      check_i_am_authorized
      click_continue_button
      database.should have_organization_matching organization_details
    end
    scenario "when I do not have the authority" do
      begin_registering_as_organization
      click_continue_button
      database.should_not have_organization_matching organization_details
    end
  end
  describe "principles" do


    scenario "user sees principle before registering", :js => true do
      goto :home
      follow_account_registration_link
      should_be_on registrations_principles_path
    end
    context "when not accepted" do
      scenario "user cannot continue to registration page", :js => true do
        goto :registration_principles
        follow_continue_as_person_link
        should_not_be_on new_person_registration_path
        should_be_on registrations_principles_path
        current_page.should have_an_error_for :must_agree_to_principles
      end
    end
    context "when accepted" do
      scenario "user continues to registration page", :js => true do
        goto :registration_principles
        check_agree
        follow_continue_as_person_link
        should_be_on new_person_registration_path
      end
    end
  end
end
