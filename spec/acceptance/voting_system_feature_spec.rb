require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!

Capybara.default_wait_time = 20


feature "Voting system", %q{
  In order to voice my opinion
  As a current user
  I want to vote on something
} do

  before(:all) do
    ActiveRecord::Observer.enable_observers
  end

  after(:all) do
    ActiveRecord::Observer.disable_observers
  end

  let (:vote_page)               { VotePage.new(page) }
  let (:login_page)              { LoginPage.new(page) }
  let (:vote_confirmation_page)  { VoteConfirmationPage.new(page)}
  let (:user_profile_page)       { UserProfilePage.new(page) }

  def given_a_registered_user
    @person = Factory.create(:registered_user, :email => 'johnd@example.com', :declined_fb_auth => true)
  end

  def given_logged_in_as_a_user
    @user = logged_in_user
  end

  def given_an_survey_with_an_issue
    @issue = Factory.create(:issue)
    @survey = Factory.create(:vote)
    @survey_option1 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @survey_option2 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 2)
    @survey_option3 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 3)
  end

  def given_an_independent_vote(opts={})
    show_progress = opts.delete(:show_progress) || false
    @vote = Factory.create(:vote,:surveyable_type => nil, :surveyable_id => nil, :show_progress => show_progress)
    @survey_option1 = Factory.create(:survey_option,:survey_id => @vote.id, :position => 1)
    @survey_option2 = Factory.create(:survey_option,:survey_id => @vote.id, :position => 2)
    @survey_option3 = Factory.create(:survey_option,:survey_id => @vote.id, :position => 3)
  end

  def given_a_survey_with_responses
    @survey_response = Factory.create(:vote_survey_response, :person_id => @user.id)
    @survey = @survey_response.survey
  end


  scenario "Voting and submitting", :js => true do
    # Given I am a registered user at The Civic Commons
    given_a_registered_user
    Notifier.deliveries = []

    # Given an independent vote
    given_an_independent_vote(:show_progress => true)

    # And I login
    login_page.sign_in(@person)

    # And I visit the vote page on the issue
    vote_page.visit_a_vote(@vote)

    # I should see 3 options available to be selected
    vote_page.should have_selector(VotePage::OPTIONS_LOCATOR, :count => 3)

    # When I drag and drop to selection
    vote_page.select_one_option

    # Then I should see 2 options left to be selected
    vote_page.should have_selector(VotePage::OPTIONS_LOCATOR, :count => 2)

    # And I should see 1 options already selected
    vote_page.should have_selector(VotePage::SELECTED_OPTIONS_LOCATOR, :count => 1)

    # When I click submit
    vote_page.click_submit
    sleep 1

    # Then a vote confirmation dialog should show up
    vote_page.should have_selector('div.modal')

    # And the vote confirmation dialog asking the user to confirm
    vote_confirmation_page.should have_selector('h2',:content => 'You are about to submit your voting selections')

    # When I click yes
    vote_confirmation_page.click_yes
    sleep 1

    # Then I should be redirected to the same page
    page.current_path.should == vote_page.independent_vote_path(@vote)

    # And I should see the vote success modal box
    sleep 1
    vote_page.should have_selector('div.modal')

    # And I should see the modal box thanking the user for voting
    vote_page.should have_selector('h2', :content => 'Thank you for voting!')

    # And an email should have been sent to me about this vote
    Notifier.deliveries.count.should == 1

    # And an activity stream should be shown that I have voted here
    user_profile_page.visit_user(@person)

    user_profile_page.should contain("#{@person.name} has participated in this Vote")
  end

  scenario "An active vote" do
    # Given I am a registered user at The Civic Commons
    given_logged_in_as_a_user
    given_an_independent_vote

    # When I see a survey
    vote_page.visit_a_vote(@vote)

    # Then I should be able to vote
    vote_page.should have_button(VotePage::SUBMIT_BUTTON_TITLE)
  end

  scenario "Association with an issue" do
    # Given an issue or conversation exists on the CC site
    @issue = Factory.create(:issue)

    # When a survey is created
    @vote = Factory.create(:vote)

    # It can be associated to the issue or conversation
    @vote.surveyable = @issue
    @vote.save
    @vote.reload.surveyable.should == @issue
  end

  scenario "An active vote associated to an Issue"  do
    # Given I am a registered user at The Civic Commons and I am logged in
    given_logged_in_as_a_user
    @issue = Factory.create(:issue)
    @vote = Factory.create(:vote)

    # When I visit a vote page associated to an Issue
    @vote.surveyable = @issue
    @vote.save
    vote_page.visit_a_vote(@vote)

    # Then I get to cast a vote
    vote_page.should have_button(VotePage::SUBMIT_BUTTON_TITLE)
  end

  scenario "Drag and drop into ballot box", :js => true do
    # Given I am a registered user who has come to a survey
    given_logged_in_as_a_user
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)

    # When there are 3 options
    vote_page.should have_selector(VotePage::OPTIONS_LOCATOR, :count => 3)

    # Then I can drag and drop these options into the ballot box in my chosen priority order
    vote_page.select_one_option
    vote_page.should have_selector(VotePage::SELECTED_OPTIONS_LOCATOR, :count => 1)
  end

  scenario "Voting and submitting", :js => true do
    # Given I am a registered user who has come to a survey who has created a ballot
    given_logged_in_as_a_user
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)
    # When I click on the cast ballot button
    vote_page.select_one_option
    vote_page.click_submit

    # Then I will have finished voting.
    sleep 1
    vote_confirmation_page.should have_selector('a', :content => 'Yes')
    vote_page.click_link_or_button('Yes')
    sleep 1
    vote_page.should have_selector('h2', :content => 'Thank you for voting!')
  end
  scenario "After submitting vote, confirmation modal appears", :js => true do
    # Given I am a registered user who has finished voting
    given_logged_in_as_a_user
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)
    vote_page.select_one_option

    # When I submit my ballot
    vote_page.click_submit
    # Then a modal message appears asking for confirmation of my vote
    vote_confirmation_page.should have_content(VoteConfirmationPage::TITLE)
  end
  scenario "Clicking yes on confirmation of vote", :js => true do
    # Given I am a registered user who has received a confirmation modal
    given_logged_in_as_a_user
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)
    vote_page.select_one_option
    vote_page.click_submit
    sleep 1
    vote_confirmation_page.should have_selector('a', :content => 'Yes')

    # When I click yes
    vote_page.click_link_or_button('Yes')
    sleep 1

    # Then my vote will be final
    vote_page.should have_selector('h2', :content => 'Thank you for voting!')
  end

  scenario "canceling vote confirmation, allows to modify vote", :js => true do
    # Given I am a registered user who has received a confirmation modal
    given_logged_in_as_a_user
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)
    vote_page.select_one_option
    vote_page.click_submit
    sleep 1
    vote_confirmation_page.should have_selector('a', :content => 'Yes')

    # When I click no
    vote_page.click_link_or_button('Cancel')

    # Then the modal closes and the ballot can be changed.
    vote_page.select_one_option
    vote_page.should have_selector(VotePage::SELECTED_OPTIONS_LOCATOR, :count => 2)
  end

  scenario "Receiving an email when finished voting.", :js => true do
    # Given I am a registered user
    given_logged_in_as_a_user
    Notifier.deliveries  = []
    given_an_survey_with_an_issue
    vote_page.visit_a_vote(@survey)

    # When I have finished the vote
    vote_page.select_one_option

    vote_page.click_submit
    sleep 1
    vote_confirmation_page.should have_selector('a', :content => 'Yes')
    vote_page.click_link_or_button('Yes')
    sleep 1

    # Then I will receive a confirmation email
    Notifier.deliveries.last.subject.should == "Thanks for your vote participation."
  end

  scenario "Receiving a Vote ended Email" do
    # Given I am a registered user
    given_logged_in_as_a_user
    given_a_survey_with_responses
    Notifier.deliveries  = []

    # When the vote end date is over
    @survey.send_end_notification_email

    # Then I will receive an end of vote email
    Notifier.deliveries.last.subject.should == "Check out the results of the \"This is a title\" vote!"
  end
  scenario "Ability to vote when the start date has not been set" do
    # Given that I am a registered user on a survey page
    given_logged_in_as_a_user

    # and a survey has been set to ‘show progress’
    # and the start date has not passed
    @survey = Factory.create(:vote, :show_progress=>true, :start_date => 2.days.from_now)

    # Then I should not be able to vote
    vote_page.visit_a_vote(@survey)

    vote_page.should_not contain(VotePage::SUBMIT_BUTTON_TITLE)

  end
end
