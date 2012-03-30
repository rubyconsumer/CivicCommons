require 'acceptance/acceptance_helper'

feature " Reflection comments", %q{
  As an visitor or user
  When I want participate in an opportunity
  I should be able to comment on reflections
} do
    
  def given_a_conversation
    @conversation = Factory.create(:conversation)
  end
  
  def given_a_reflection(options={})
    @reflection = Factory.create(:reflection, options)
    @conversation = @reflection.conversation
  end

  scenario "Creating and viewing a reflection comment", :js => true do
    given_a_reflection
    login_as :person

    visit conversation_reflection_path(@conversation, @reflection)
    set_current_page_to :reflection
    click_create_invalid_comment_button
    current_page.should have_error
    
    fill_in_comment_body_with 'Comment Body here'
    click_create_comment_button
    current_page.should_not have_error
    current_page.should have_content 'Comment Body here'
    
    visit conversation_reflections_path(@conversation)
    set_current_page_to :reflections
    current_page.should have_content '1 comment'
    current_page.should have_content 'Leave a comment'
  end
  

end