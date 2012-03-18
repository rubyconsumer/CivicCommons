require 'acceptance/acceptance_helper'

feature " Actions", %q{
  As an visitor or user
  When I want participate in an Action
  I should be able to
} do
    
  def given_a_conversation
    @conversation = Factory.create(:conversation)
  end
  
  def given_a_petition(options={})
    @petition = Factory.create(:petition, options)
    @conversation = @petition.conversation
  end

  scenario "Viewing a list of actions", :js => true do
    given_a_petition(:title => 'Petition Title here')
    login_as :person
    visit conversation_actions_path(@conversation)
    
    page.should have_content 'Petition Title here'
  end
  

end