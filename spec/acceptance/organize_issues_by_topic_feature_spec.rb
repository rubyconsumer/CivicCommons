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

  scenario "topics with no issues should not show up" do
    database.has_a_topic_without_issues
    goto :issues_index
    current_page.should_not have_listed topic_without_issues
  end

  scenario "issues that shouldnt exist dont get counted" do
    database.has_an_issue :topics => [topic], :exclude_from_result=>true
    goto :issues_index
    current_page.should have_number_of_issues_for(topic, 1)
  end

  def issue
    database.latest_issue
  end

  def topic_without_issues
    database.latest_topic
  end

  def topic
    database.latest_topic
  end
end
