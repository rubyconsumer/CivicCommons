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
  

end