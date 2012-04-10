require 'acceptance/acceptance_helper'

feature " Petitions", %q{
  As an visitor or user
  When I want participate in a petition
  I should be able to
} do

  def given_a_conversation
    @conversation = FactoryGirl.create(:conversation)
  end

  def given_a_petition(options={})
    @petition = FactoryGirl.create(:petition, options)
    @conversation = @petition.conversation

    @petition.instance_eval do
      def container
        "[data-petition-id='#{self.id}']"
      end
    end
  end

  scenario "Creating and viewing a petition", :js => true do
    given_a_conversation
    login_as :person
    visit new_conversation_petition_path(@conversation)

    set_current_page_to :new_petition

    click_start_invalid_petition_button
    current_page.should have_error

    fill_in_title_with 'Title here'
    fill_in_description_with 'Description here'
    fill_in_resulting_actions_with 'resulting action here'
    fill_in_signature_needed_with '12'

    click_start_petition_button
    page.should have_content 'Title here'
    page.should have_content 'Description here'
    page.should have_content 'resulting action here'
  end

  scenario "signing a petition", :js => true do
    given_a_petition(:signers=>[])
    login_as :person

    visit conversation_petition_path(@conversation, @petition)
    set_current_page_to :petition

    current_page.should_not have_content 'Signatures'

    follow_sign_petition_link
    sleep 1

    follow_confirm_sign_petition_link

    current_page.should_not have_content 'Sign the Petition'
    current_page.should have_content 'Signatures'
    current_page.should have_selector('.photobank.signatures a img', :count => 1)
  end

  scenario "View summary count of petition signatures " do
    given_a_petition(:signature_needed => 12)
    login_as :person

    visit conversation_petition_path(@conversation, @petition)
    set_current_page_to :petition

    current_page.should have_content '1 out of 12'
    current_page.should have_content "11 more signatures needed"
  end

  scenario "Moderating a petition", :js => true do
    given_a_petition(:title => 'Existing Title Here')
    login_as :admin_person
    visit conversation_actions_path(@conversation)
    set_current_page_to :actions

    current_page.should have_content 'Existing Title Here'
    current_page.should have_content 'Moderate'
    current_page.should have_content 'Edit'
    current_page.should have_content 'Delete'

    follow_edit_petition_link_for(@petition)
    fill_in_title_with 'New Title here'

    click_update_petition_button
    current_page.should have_content 'New Title here'

    visit conversation_actions_path(@conversation)
    set_current_page_to :actions
    current_page.should have_content 'Moderate'
    current_page.should have_content 'Edit'
    current_page.should have_content 'Delete'

    follow_delete_petition_link_for(@petition)
    accept_alert

    current_page.should_not have_content 'New Title here'
  end
  scenario "Moderating a petition as a user is NOT allowed" do
    given_a_petition
    login_as :person
    visit conversation_actions_path(@conversation)
    set_current_page_to :actions
    current_page.should_not have_content 'Moderate'
    current_page.should_not have_content 'Edit'
    current_page.should_not have_content 'Delete'

    visit conversation_petition_path(@conversation, @petition)
    set_current_page_to :petition
    current_page.should_not have_content 'Moderate'
    current_page.should_not have_content 'Edit'
    current_page.should_not have_content 'Delete'

  end


end
