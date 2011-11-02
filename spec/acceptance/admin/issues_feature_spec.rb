require 'acceptance/acceptance_helper'

feature "Issue Admin", %q{
  In order to organize our conversations
  As an admin
  I want to be able to modify issues

} do

  scenario "forgetting to assign topics to issues" do
    login_as :admin
    when_i_create_an_issue_without_a_topic
    then_i_am_reminded_to_add_topics
  end

  scenario "assign topics to issues" do
    login_as :admin
    when_i_create_an_issue_with_topics 
    then_it_has_the_topics_i_assigned
  end
end
