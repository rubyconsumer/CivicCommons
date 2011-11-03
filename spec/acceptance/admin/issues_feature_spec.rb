require 'acceptance/acceptance_helper'

feature "Issue Admin", %q{
  In order to organize our conversations
  As an admin
  I want to be able to modify issues

} do
  background do
    database.create_topic
  end
  scenario "forgetting to assign topics to issues" do
    goto_admin_page_as_admin
    submit_an_issue_without_a_topic
    current_page.should have_reminder_to_add_topics 
    database.should_not have_any_issues
  end

  scenario "assign topics to issues", :js => true do
    goto_admin_page_as_admin
    submit_an_issue_with_topics 
    issue.should have_topic topic_i_added 
  end

  def submit_an_issue_without_a_topic
    follow_add_issue_link  
    fill_in_issue_with :topics => []
    click_create_issue_while_in_invalid_state_button
  end
  def submit_an_issue_with_topics
    follow_add_issue_link  
    fill_in_issue_with defaults 
    click_create_issue_button
    save_and_open_page
  end 

  def topics_i_assigned

  end
  def issue
    Issue.last
  end
end
