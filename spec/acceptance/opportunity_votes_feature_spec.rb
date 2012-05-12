require 'acceptance/acceptance_helper'

feature " Opportunity Votes", %q{
  As an visitor or user
  When I want participate in an opportunity votes
  I should be able to create and view votes, make a vote, and more.
} do
    
  def given_a_conversation
    @conversation = FactoryGirl.create(:conversation)
  end
  
  def given_a_vote(options={})
    @vote = FactoryGirl.create(:vote, options)
  end
  
  def given_a_vote_with_a_conversation(options={})
    @conversation = given_a_conversation
    @vote = given_a_vote(options.merge({:surveyable => @conversation}))
  end
  
  scenario "Ability to display a list of actions for votes.", :js => true do
    given_a_vote_with_a_conversation(:title => 'Vote title here')
    login_as :person
    visit conversation_actions_path(@conversation)
    current_page.should have_content('Vote title here')
  end
  
  scenario "Ability to create a vote from an opportunity actions page", :js => true do
    given_a_conversation
    login_as :person
    visit conversation_actions_path(@conversation)
    set_current_page_to :actions
    follow_suggest_an_action_link
    follow_take_a_vote_link
    current_page.should have_content 'New Vote'
  end
  
  scenario "Ability to add an option on the new votes page", :js => true do
    given_a_vote_with_a_conversation(:title => 'Vote title here')
    login_as :person
    visit new_conversation_vote_path(@conversation)
    set_current_page_to :new_opportunity_vote
    current_page.should have_selector '.survey-option', :count => 1
    follow_add_option_link
    current_page.should have_selector '.survey-option', :count => 2
    click_publish_invalid_vote_button
    current_page.should have_content 'There were errors saving this vote.'
  end
  
  scenario "Ability to delete an option on the new votes page", :js => true do
    given_a_vote_with_a_conversation(:title => 'Vote title here')
    login_as :person
    visit new_conversation_vote_path(@conversation)
    set_current_page_to :new_opportunity_vote
    current_page.should have_selector '.survey-option', :count => 1
    follow_delete_option_link
    accept_alert
    current_page.should_not have_selector '.survey-option'
    click_publish_invalid_vote_button
    current_page.should have_content 'There were errors saving this vote.'
  end

end