require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 10

feature "Add contribution", %q{
  As a Civic Commons registered user
  I want to add a contribution
  So that I can interact with the Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end

  scenario "Modal pops up when user responds to a conversation", :js => true do
    #Given I am on a conversation permalink page
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    #When I click on the contribute to conversation button
    @conversation_page.click_post_to_the_conversation
    #Then I should see a contribution modal overlay appear
    @conversation_page.should have_contribution_modal_present
    #And I should see links to comment
    @conversation_page.should have_link('Comment')
    #And I should see links to suggest action
    @conversation_page.should have_link('Suggest Action')
    #And I should see links to question
    @conversation_page.should have_link('Question')
    #And I should see links to attach
    @conversation_page.should have_link('Attach')
    #And I should see links to link 
    @conversation_page.should have_link('Link')
    #And I should see links to video
    @conversation_page.should have_link('Video')
    #And I should see comments selected
    @conversation_page.should have_active_tab('Comment')
  end

  scenario "Modal pops up when responding to contribution", :js => true do
    #Given that I am on a conversation permalink page
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    #And I am on a conversation node
    @conversation_page.visit_node(@conversation, @contribution)
    #When I click on the respond to contribution link
    @conversation_page.respond_to_contribution(@contribution)
    #Then I should see the contribution modal overlay appear
    @conversation_page.should have_contribution_modal_present
  end

  scenario "Previewing a comment", :js => true do
    #Given that I am at the contribution modal
    @conversation_page = ConversationPage.new(page)
    @conversation_page.visit_page(@conversation)
    @conversation_page.click_post_to_the_conversation
    #When I fill in the comments text box with “the cat in the hat”
    page.has_css?('textarea#contribution_content', visible: true)
    fill_in 'contribution_content', :with => "the cat in the hat"
    #And I click the preview button
    click_button('Preview')
    #Then I should see a preview modal with the content “the cat in the hat”
    find("#cboxLoadedContent div.comment div.content p").should_not be_nil
    page.should have_content "the cat in the hat"
    #And I should I should see a submit button
    page.has_css?('#contribution_submit').should be_true
    #And I should I should see a cancel link
    page.has_css?('a.cancel').should be_true
  end

  scenario "Posting a comment", :js => true do
    #Given I have previewed a comment for a contribution
    preview_comment(@conversation, "the cat in the hat")
    #When I submit I should be back on the conversation page 
    find('#contribution_submit', visible: true).click
    #Then I should be directed back to the contribution
    visit "#{conversation_path(@conversation)}#node-#{@conversation.contributions.last.id}"
    #And this contribution should be on the conversation page
    page.has_content?('the cat in the hat').should be_true
  end

  scenario "Canceling a comment", :js => true do
    #Given I am previewing my comment "the cat in the hat"
    preview_comment(@conversation, "the cat in the hat")
    #When I click on the cancel link
    find('a.cancel', visible: true).click
    #Then I should see the contribution modal with the words “the cat in the hat”
    find('textarea#contribution_content').should_not be_nil
    page.should have_content('the cat in the hat')
  end

end
