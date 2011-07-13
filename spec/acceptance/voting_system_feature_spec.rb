require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.register_driver :selenium do |app|
  Capybara::Driver::Selenium.new(app, :browser => :chrome)
end

Capybara.default_wait_time = 20


feature "Voting system", %q{
  In order to voice my opinion
  As a current user
  I want to vote on something
} do
  
  let (:vote_page)               { VotePage.new(page) }
  let (:login_page)              { LoginPage.new(page) }
  let (:vote_confirmation_page)  { VoteConfirmationPage.new(page)} 
  
  def given_a_registered_user
    @person = Factory.create(:registered_user, :email => 'johnd@example.com', :declined_fb_auth => true)
  end
  
  def given_an_issue
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

  scenario "Voting and submitting", :js => true do
    # Given I am a registered user at The Civic Commons
    given_a_registered_user
    
    # Given an issue
    given_an_issue
    
    # And I login
    login_page.sign_in(@person)
    
    # And I visit the vote page on the issue
    # vote_page.visit_vote_on_an_issue(@issue)
    vote_page.visit_an_independent_vote(@survey)
    
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
    
    # And I should see 2 options left to be selected
    vote_page.should have_selector(VotePage::OPTIONS_LOCATOR, :count => 2)
    
    # And I should see 1 options already selected
    vote_page.should have_selector(VotePage::SELECTED_OPTIONS_LOCATOR, :count => 1)
    
  end
  
  scenario "Voting and submitting and seeing the votes progress", :js => true do
    # Given I am a registered user at The Civic Commons
    given_a_registered_user
    
    # Given an independent vote
    given_an_independent_vote(:show_progress => true)
    
    # And I login
    login_page.sign_in(@person)
    
    # And I visit the vote page on the issue
    vote_page.visit_an_independent_vote(@vote)
    
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
    
    # Then I should be redirected to the same page
    page.current_path.should == vote_page.independent_vote_path(@vote)
    
    # And I should see the title telling that the user have voted
    vote_page.should have_selector('h1',:content => "You've already voted.")

    # And I should see the vote progress chart from Google
    vote_page.should have_selector('img.google-chart')

    # And I should see the vote success modal box
    vote_page.should have_selector('div.modal')
    
    # And I should see the modal box thanking the user for voting
    vote_page.should have_selector('h2', :content => 'Thanks for Voting')
    
    # And an activity stream should be shown that I have voted here
    
    # And an email should have been sent to me about this vote
  end
  
  
  scenario "Voting and submitting and NOT seeing the votes progress", :js => true do
    # Given I am a registered user at The Civic Commons
    given_a_registered_user
    
    # Given an independent vote
    given_an_independent_vote(:show_progress => false)
    
    # And I login
    login_page.sign_in(@person)
    
    # And I visit the vote page on the issue
    vote_page.visit_an_independent_vote(@vote)
    
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
    
    # Then I should be redirected to the same page
    page.current_path.should == vote_page.independent_vote_path(@vote)
    
    # And I should see the title telling that the user have voted
    vote_page.should have_selector('h1',:content => "You've already voted.")
    
    # And I should NOT see the vote progress chart from Google
    vote_page.should_not have_selector('img.google-chart')

    # And I should see the vote success modal box
    vote_page.should have_selector('div.modal')
    
    # And I should see the modal box thanking the user for voting
    vote_page.should have_selector('h2', :content => 'Thanks for Voting')
    
    # And an activity stream should be shown that I have voted here
    
    # And an email should have been sent to me about this vote
  end  
end
