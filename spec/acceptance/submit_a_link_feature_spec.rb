require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Submit a link", %q{
  As a registered user at The Civic Commons
  I want to submit links
  So that I can interact with The Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end


  scenario "Previwing a link", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #And I have submitted the link with the comment 'Go here for more...'
    @conversation_page.respond_with_link(@conversation, 'Go here for more...')
    @conversation_page.click_submit_contribution
    #Then I should see a preview modal with the content “Go here for more...”
    @conversation_page.should have_content('Go here for more...')
    #And I should I should see a submit button
    @conversation_page.should have_css('#contribution_submit')
    #And I should I should see a cancel link
    @conversation_page.should have_css('a.cancel')
  end

  scenario "Posting the link", :js => true do
    #Given I have previewed a link for a contribution
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_link(@conversation, 'Go here for more...')
    #Then I should see a preview modal with the content “Go here for more...”
    @conversation_page.should have_preview_contribution_text('Go here for more...')
    #When I submit I should be back on the conversation page 
    @conversation_page.click_submit_contribution
    #Then I should be directed back to the contribution
    @conversation_page.visit_node(@conversation, @conversation.contributions.last)
    #And this contribution should be on the conversation page
    @conversation_page.should have_contribution('Go here for more...')
  end

  scenario "Canceling a link", :js => true do
    #Given I am previewing my link "Go here for more..."
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_link(@conversation, 'Go here for more...')
    #When I click on the cancel link
    @conversation_page.click_cancel_contribution
    #Then I should see the contribution modal with the words “Go here for more...”
    @conversation_page.should have_preview_contribution_text('Go here for more...')
  end

end
