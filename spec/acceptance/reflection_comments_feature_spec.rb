require 'acceptance/acceptance_helper'

feature " Reflection comments", %q{
  As an visitor or user
  When I want participate in an opportunity
  I should be able to comment on reflections
} do
    
  def given_a_conversation
    @conversation = FactoryGirl.create(:conversation)
  end
  
  def given_a_reflection(options={})
    @reflection = FactoryGirl.create(:reflection, options)
    @conversation = @reflection.conversation
  end
  
  def given_a_reflection_with_comments(options={})
    @reflection = FactoryGirl.create(:reflection_with_comments, options)
    @conversation = @reflection.conversation
    @comment = @reflection.comments.first
    @reflection = @comment.reflection
    @comment.instance_eval do
      def container
        "[data-reflection-comment-id='#{self.id}']"
      end
    end
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
  
  scenario "moderating a reflection comment", :js => true do
    given_a_reflection_with_comments
    
    login_as :admin_person
    
    visit conversation_reflection_path(@conversation, @reflection)
    set_current_page_to :reflection

    current_page.should have_content 'Body comment here'
    current_page.should have_content 'Moderate'
    current_page.should have_content 'Edit'
    current_page.should have_content 'Delete'
    
    follow_edit_comment_link_for(@comment)
    fill_in_comment_body_with 'New Body comment here'    
    
    click_update_comment_button
    current_page.should have_content 'New Body comment here'
    
    visit conversation_reflection_path(@conversation, @reflection)
    set_current_page_to :reflection
    current_page.should have_content 'Moderate'
    current_page.should have_content 'Edit'
    current_page.should have_content 'Delete'
    
    follow_delete_comment_link_for(@comment)
    accept_alert
    
    current_page.should_not have_content 'New Body comment here'    
    
  end

end