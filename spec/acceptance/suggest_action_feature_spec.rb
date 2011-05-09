require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Suggest an action", %q{
  As a Civic Commons registered user
  I want to suggest an action
  So that I can interact with the Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end


  scenario "Previewing suggested action", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #And I have suggested the action to "We should do..."
    @conversation_page.respond_with_suggestion(@conversation, 'We should do...')
    @conversation_page.click_submit_contribution
    #Then I should see a preview modal with the content “We should do...”
    @conversation_page.should have_content('We should do...')
    #And I should I should see a submit button
    @conversation_page.should have_css('#contribution_submit')
    #And I should I should see a cancel link
    @conversation_page.should have_css('a.cancel')
  end

  scenario "Posting the suggested action", :js => true do
    #Given I have previewed a suggested action for a contribution
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_suggestion(@conversation, 'We should do...')
    #Then I should see a preview modal with the content “We should do...”
    @conversation_page.should have_preview_contribution_text('We should do...')
    #When I submit I should be back on the conversation page 
    @conversation_page.click_submit_contribution
    #Then I should be directed back to the contribution
    @conversation_page.visit_node(@conversation, @conversation.contributions.last)
    #And this contribution should be on the conversation page
    @conversation_page.should have_contribution('We should do...')
  end

  scenario "Canceling a suggested action", :js => true do
    #Given I am previewing my comment "the cat in the hat"
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_suggestion(@conversation, 'We should do...')
    #When I click on the cancel link
    @conversation_page.click_cancel_contribution
    #Then I should see the contribution modal with the words “the cat in the hat”
    @conversation_page.should have_preview_contribution_text('We should do...')
  end

end
