require 'acceptance/acceptance_helper'

feature 'Organize Issues By Topic', %q{
  In order to find issues more easily
  As anyone browsing the site
  I would like to see which topics an issue is related to 
} do

  background do
    database.has_a_topic
    database.has_an_issue :topics => [topic]
  end

  scenario "topic visible on issue detail page" do
    goto :issue_detail, :for=>issue
    current_page.should have_filed(issue, :under=> topic)
  end

  scenario "topic visible on issues index page" do
    goto :issues_index
    current_page.should have_filed(issue, :under=>topic)
  end

  scenario "clicking a topic takes you to the issues page filtered to that topic" do
    goto :issue_detail, :for=>issue
    follow_topic_link_for topic
    current_page.should be_filtered_by topic
  end

  def issue
    database.latest_issue
  end

  def topic
    database.latest_topic
  end
end
