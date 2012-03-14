require 'acceptance/acceptance_helper'

feature " Petitions", %q{
  As an visitor or user
  When I want participate in a petition
  I should be able to
} do
    
  def given_a_conversation
    @conversation = Factory.create(:conversation)
  end
  
  def given_a_petition(options={})
    @petition = Factory.create(:petition, options)
    @conversation = @petition.conversation
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
    fill_in_end_on_with 'February 29, 2012'
    
    click_start_petition_button
    page.should have_content 'Title here'
    page.should have_content 'Description here'
    page.should have_content 'resulting action here'
  end
  
  scenario "signing a petition", :js => true do
    given_a_petition
    login_as :person
    
    visit conversation_petition_path(@conversation, @petition)
    set_current_page_to :petition
    
    follow_sign_petition_link
    sleep 1
    
    follow_confirm_sign_petition_link
    
    current_page.should_not have_content 'Sign the Petition'
  end

  scenario "the inability to sign an expired petition", :js => true do
    given_a_petition(:end_on=> 2.days.ago)
    login_as :person
    
    visit conversation_petition_path(@conversation, @petition)
    set_current_page_to :petition
    
    current_page.should_not have_content 'Sign the Petition'
  end
  

end