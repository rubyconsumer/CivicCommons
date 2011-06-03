require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Attach a file", %q{
  As a registered user at The Civic Commons
  I want to attach a file
  So that I can interact with The Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end


  scenario "Previwing an attachment", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #And I have attached the file 'example/file.txt' and commented 'Check it out'
    @conversation_page.respond_with_attachment(@conversation, 'Check it out')
    @conversation_page.click_submit_contribution
    #Then I should see a preview modal with the content “What if we...?”
    @conversation_page.should have_content('Check it out')
    #And I should I should see a submit button
    @conversation_page.should have_css('#contribution_submit')
    #And I should I should see a cancel link
    @conversation_page.should have_css('a.cancel')
  end

  scenario "Posting the attachment", :js => true do
    #Given I have previewed an attachment
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_attachment(@conversation, 'Check it out')
    #Then I should see a preview modal with the content “We should do...”
    @conversation_page.should have_preview_contribution_text('Check it out')
    #When I submit I should be back on the conversation page 
    @conversation_page.click_submit_contribution
    #Then I should be directed back to the contribution
    @conversation_page.visit_node(@conversation, @conversation.contributions.last)
    #And this contribution should be on the conversation page
    @conversation_page.should have_contribution('Check it out')
  end

  scenario "Canceling an attachment", :js => true do
    #Given I am previewing my attchment
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_attachment(@conversation, 'What if we...?')
    #When I click on the cancel link
    @conversation_page.click_cancel_contribution
    #Then I should see the contribution modal with the words “What if we...?”
    @conversation_page.should have_preview_contribution_text('What if we...?')
  end

end
