require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

WebMock.allow_net_connect!
# Capybara.register_driver :selenium do |app|
#   Capybara::Driver::Selenium.new(app, :browser => :chrome)
# end
Capybara.default_wait_time = 10


feature "Voting results", %q{
  In order to know the results of a vote
  As a user
  I want to see the voting results, when available.
} do

  def given_logged_in_as_a_user
    @user = logged_in_user
  end
  def given_an_issue
    @issue = Factory.create(:issue)
  end
  def given_a_survey_with_responses
    @survey_response = Factory.create(:vote_survey_response, :person_id => @user.id)
    @survey = @survey_response.survey
  end
  
  let (:vote_page)               { VotePage.new(page) }    

  scenario "Showing of the results when the end date have passed" do
    # Given that I am any user
    given_logged_in_as_a_user
    
    # and a survey has been set to ‘show progress’
    given_a_survey_with_responses
    @survey.show_progress = true
    
    # and the end date has passed
    @survey.end_date = 2.days.ago
    @survey.save
    
    # When I am on a survey page
    Survey.count.should == 1
    vote_page.visit_an_independent_vote(Survey.last)
    
    # Then I should be able to see the results
    vote_page.should have_selector(VotePage::VOTE_RESULTS)
    
    # and the ballot box should be read only
    vote_page.should have_selector(VotePage::BALLOT_FORM_DISABLED)
  end
  
  scenario "Not showing result when show progress is OFF" do
    # Given that I am any user
    given_logged_in_as_a_user
    
    # and a survey has not been set to ‘show progress’
    given_a_survey_with_responses
    @survey.show_progress = false
    @survey.save
    
    # When I am on a survey page
    vote_page.visit_an_independent_vote(Survey.last)
    
    # Then I should not be able to see the results
    vote_page.should_not have_selector(VotePage::VOTE_RESULTS)
  end
  
  scenario "Not showing result when End Date hasn't pass" do
    # Given that I am any user
    given_logged_in_as_a_user
    
    # and a survey has been set to ‘show progress’
    given_a_survey_with_responses
    @survey.show_progress = true

    # and has been associated to an Issue
    given_an_issue
    @survey.surveyable = @issue

    
    # and the end date has not passed
    @survey.end_date = 2.days.from_now
    @survey.save
    
    # When I am on a survey page
    vote_page.visit_an_independent_vote(Survey.last)
    
    # Then I should not be able to see the results
    vote_page.should_not have_selector(VotePage::VOTE_RESULTS)
    
    # and I should be able to see a link to return to the associated Issue or Conversation
    vote_page.should contain "Back to: #{Survey.last.surveyable.name}"
    vote_page.should have_link(Survey.last.surveyable.name,:href => issue_path(@issue))
  end
  
  scenario "Not showing result when show progress is set, and start date has not passed" do
    # Given that I am any user
    given_logged_in_as_a_user

    # and a survey has been set to ‘show progress’
    given_a_survey_with_responses
    @survey.show_progress = true
    
    # and the start date has not passed
    @survey.start_date = 2.days.from_now
    @survey.save
    
    # When I am on a survey page
    vote_page.visit_an_independent_vote(Survey.last)
    
    # Then I should not be able to see the results
    vote_page.should_not have_selector(VotePage::VOTE_RESULTS)
  end

end


