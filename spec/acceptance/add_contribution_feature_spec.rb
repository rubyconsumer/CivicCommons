require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

WebMock.allow_net_connect!
Capybara.default_wait_time = 10

feature "Add contribution", %q{
  As a registered user at The Civic Commons
  I want to add a contribution
  So that I can interact with the community

  Scenario: 
} do

  let(:content) do
    content = 'This is my contribution...'
  end
  let(:file_and_url_error_message) do
    content = "Woops! We only let you submit one link or file per contribution"
  end
  
  let(:file_only_error_message) do
    content = "Sorry! You must also write a comment above when you upload a file."
  end

  let(:url) do
    # because of WebMock this URL will always be mocked to/from Embedly
    # /test/fixtures/embedly/youtube.json
    # /spec/support/stubbed_http_requests.rb
    'http://www.youtube.com/watch?v=djtNtt8jDW4'
  end

  let(:file_path) do
    'test/fixtures/cc_logos.pdf'
  end

  background do

    # Given I am logged in
    @user = logged_in_user
    
    # Then a conversation with at least one contribution exists
    @contribution = Factory.create(:contribution_without_parent, :override_confirmed => true)
    @conversation = @contribution.conversation

  end

  scenario "Contribution tool is hidden by default", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # Then I should not see the contribution tool
    contrib.should_not be_visible
  end

  scenario "Contribution tool appears when a user posts to a conversation", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to button
    contrib.post_to_link.click 

    # Then I should see the contribution tool
    contrib.should be_visible
  end

  scenario "Contribution tool appears when a user responds to a root-level contribution", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the respond-to button
    contrib.respond_to_link(@contribution).click 

    # Then I should see the contribution tool
    contrib.should be_visible
  end

  scenario "Contribution tool appears when a user responds to a child contribution", :js => true do

    # Given a child contribution exists
    child = Factory.create(:contribution,
                           :override_confirmed => true,
                           :conversation => @conversation,
                           :parent => @contribution)

    # Given I am on a conversation node permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_node(@conversation, child)
    sleep(1)

    contrib = ContributionTool.new(page)

    # When I click on the respond-to button
    contrib.respond_to_link(child).click     # need to see if the child is available to be clicked

    # Then I should see the contribution tool
    contrib.should be_visible
  end

  scenario "Contribution tool has all required elements", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # Then I should not see the content textarea
    contrib.content_field.should_not be_visible

    # Then I should see the WYSIWYG editor
    contrib.wysiwyg_editor.should be_visible

    # Then I should see the 'Add a link...' link
    contrib.add_url_link.should be_visible

    # Then the link field should be hidden
    contrib.url_field.should_not be_visible

    # Then I should see the 'Add a file...' link
    contrib.add_file_link.should be_visible

    # Then the file field should be hidden
    contrib.file_field.should_not be_visible

    # Then I should see the Submit button
    contrib.submit_button.should be_visible

    # Then I should see the Cancel link
    contrib.cancel_link.should be_visible

    # When I click the 'Add a link...' link
    contrib.add_url_link.click
    
    # Then the link field should be visible
    contrib.url_field.should be_visible

    # When I click the 'Add a file...' link
    contrib.add_file_link.click
    
    # Then the file field should be visible
    contrib.file_field.should be_visible
 end

  scenario "Cancelling a contribution", :js => true do
    # NOTE: This test occationally has timing issues
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # Then I should see the contribution tool
    contrib.should be_visible
    
    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the 'Add a link...' link
    contrib.add_url_link.click

    # When I fill in the url field
    contrib.fill_in_url_field(url)

    # When I click the 'Add a file...' link
    contrib.add_file_link.click

    # When I fill in the file field
    contrib.select_file(file_path)

    # When I click the Cancel link
    contrib.cancel_link.click

    # Then I should not see the contribution tool
    contrib.should_not be_visible
  end

  scenario "Posting only a comment", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see my contribution
    convo_page.should have_content(content)

    # Then I should see a link to my profile
    contrib.should have_link(@user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting only a url", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I click the 'Add a link...' link
    contrib.add_url_link.click

    # When I fill in the url field
    contrib.fill_in_url_field(url)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see a link to my url
    contrib.should have_css("a[href='#{url}']")

    # Then I should see a link to my profile
    contrib.should have_link(@user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting only a file - is not allowed", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I click the 'Add a file...' link
    contrib.add_file_link.click

    # When I fill in the file field
    contrib.select_file(file_path)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see an error
    contrib.should contain(file_only_error_message)

    # And I should still see the contribution tool
    contrib.should be_visible

  end

  scenario "Posting a comment with a url", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the 'Add a link...' link
    contrib.add_url_link.click

    # When I fill in the url field
    contrib.fill_in_url_field(url)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see my contribution
    convo_page.should have_content(content)

    # Then I should see a link to my url
    contrib.should have_css("a[href='#{url}']")

    # Then I should see a link to my profile
    contrib.should have_link(@user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting a comment with a file", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the 'Add a file...' link
    contrib.add_file_link.click

    # When I fill in the file field
    contrib.select_file(file_path)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see my contribution
    convo_page.should have_content(content)

    # Then I should see a link to my file
    convo_page.should have_link('Download attached file')

    # Then I should see a link to my profile
    contrib.should have_link(@user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting a url with a file, is not allowed - must be either a url or a file", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I click the 'Add a link...' link
    contrib.add_url_link.click

    # When I fill in the url field
    contrib.fill_in_url_field(url)

    # When I click the 'Add a file...' link
    contrib.add_file_link.click

    # When I fill in the file field
    contrib.select_file(file_path)

    # And I press the submit button
    contrib.submit_button.click
    
    # Then I should see an error message
    contrib.should contain(file_and_url_error_message)

    # And I should still see the contribution tool
    contrib.should be_visible

  end

  scenario "Posting a comment with a file and a url is not allowed - must be either a url or a file", :js => true do
 
    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(@conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click 

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the 'Add a link...' link
    contrib.add_url_link.click

    # When I fill in the url field
    contrib.fill_in_url_field(url)

    # When I click the 'Add a file...' link
    contrib.add_file_link.click

    # When I fill in the file field
    contrib.select_file(file_path)

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see an error message
    contrib.should contain(file_and_url_error_message)

    # And I should still see the contribution tool
    contrib.should be_visible

  end

end
