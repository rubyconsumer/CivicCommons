require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Ask a question", %q{
  As a registered user at The Civic Commons
  I want to ask a question
  So that I can interact with The Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end


  scenario "Previwing a question", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #And I have asked the question "What if we...?"
    @conversation_page.respond_with_question(@conversation, 'What if we...?')
    @conversation_page.click_submit_contribution
    #Then I should see a preview modal with the content “What if we...?”
    @conversation_page.should have_content('What if we...?')
    #And I should I should see a submit button
    @conversation_page.should have_css('#contribution_submit')
    #And I should I should see a cancel link
    @conversation_page.should have_css('a.cancel')
  end

  scenario "Posting the question", :js => true do
    #Given I have previewed a question for a contribution
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_question(@conversation, 'What if we...?')
    #Then I should see a preview modal with the content “We should do...”
    @conversation_page.should have_preview_contribution_text('What if we...?')
    #When I submit I should be back on the conversation page 
    @conversation_page.click_submit_contribution
    #Then I should be directed back to the contribution
    @conversation_page.visit_node(@conversation, @conversation.contributions.last)
    #And this contribution should be on the conversation page
    @conversation_page.should have_contribution('What if we...?')
  end

  scenario "Canceling a suggested action", :js => true do
    #Given I am previewing my question "What if we...?"
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_question(@conversation, 'What if we...?')
    #When I click on the cancel link
    @conversation_page.click_cancel_contribution
    #Then I should see the contribution modal with the words “What if we...?”
    @conversation_page.should have_preview_contribution_text('What if we...?')
  end

end
