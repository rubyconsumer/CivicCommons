require 'acceptance/acceptance_helper'

feature "BlogPost Admin", %q{
  In order to organize our conversations
  As an admin
  I want to be able to modify radio shows

} do
  background do
    database.has_a_topic
    goto_admin_page_as_admin
  end

  scenario "forgetting to assign topics to radio shows" do
    submit_a_radio_show_without_a_topic
    current_page.should have_reminder_to_add_topics
    database.should_not have_any_radio_shows
  end

  scenario "assign topics to radio shows", :js => true do
    submit_a_radio_show_with_topic
    database.latest_radio_show.should have_topic database.latest_topic
  end

  def submit_a_radio_show_without_a_topic
    follow_add_content_item_link
    fill_in_radio_show_with :topics => []
    click_create_content_item_while_in_invalid_state_button
  end

  def submit_a_radio_show_with_topic
    follow_add_content_item_link
    fill_in_radio_show_with defaults
    click_create_content_item_button
  end
end