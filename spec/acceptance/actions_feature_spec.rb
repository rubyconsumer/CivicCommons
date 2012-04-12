require 'acceptance/acceptance_helper'

feature " Actions", %q{
  As an visitor or user
  When I want participate in an Action
  I should be able to
} do
    
  def given_a_conversation
    @conversation = FactoryGirl.create(:conversation)
  end
  
  def given_a_petition(options={})
    @petition = FactoryGirl.create(:petition, options)
    @conversation = @petition.conversation
  end

  scenario "Viewing a list of actions", :js => true do
    given_a_petition(:title => 'Petition Title here')
    login_as :person
    visit conversation_actions_path(@conversation)
    
    page.should have_content 'Petition Title here'
  end

  scenario "Suggest an Action", :js => true do
    given_a_petition(:title => 'Petition Title here')
    login_as :person
    visit conversation_actions_path(@conversation)
    set_current_page_to :actions
    follow_suggest_an_action_link
    follow_write_a_petition_link
  end
  

end