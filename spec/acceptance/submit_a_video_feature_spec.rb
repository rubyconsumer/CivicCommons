require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Submit a video", %q{
  As a Civic Commons registered user
  I want to submit videos
  So that I can interact with the Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end


  scenario "Previwing a video", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #And I have submitted the video with the comment 'Watch this'
    @conversation_page.respond_with_video(@conversation, 'Watch this')
    @conversation_page.click_submit_contribution
    #Then I should see a preview modal with the content “Watch this”
    @conversation_page.should have_content('Watch this')
    #And I should I should see a submit button
    @conversation_page.should have_css('#contribution_submit')
    #And I should I should see a cancel video
    @conversation_page.should have_css('a.cancel')
  end

  scenario "Posting the video", :js => true do
    #Given I have previewed a video for a contribution
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_video(@conversation, 'Watch this')
    #Then I should see a preview modal with the content “Watch this”
    @conversation_page.should have_preview_contribution_text('Watch this')
    #When I submit I should be back on the conversation page 
    @conversation_page.click_submit_contribution
    #Then I should be directed back to the contribution
    @conversation_page.visit_node(@conversation, @conversation.contributions.last)
    #And this contribution should be on the conversation page
    @conversation_page.should have_contribution('Watch this')
  end

  scenario "Canceling a video", :js => true do
    #Given I am previewing my video "Watch this"
    @conversation_page = ConversationPage.new(page)
    @conversation_page.preview_video(@conversation, 'Watch this')
    #When I click on the cancel video
    @conversation_page.click_cancel_contribution
    #Then I should see the contribution modal with the words “Watch this”
    @conversation_page.should have_preview_contribution_text('Watch this')
  end

end
