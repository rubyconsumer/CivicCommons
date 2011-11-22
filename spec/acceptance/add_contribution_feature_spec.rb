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
    'This is my contribution...'
  end
  let(:file_and_url_error_message) do
    "Woops! We only let you submit one link or file per contribution"
  end

  let(:file_only_error_message) do
    "Sorry! You must also write a comment above when you upload a file."
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

    login_as :person
    create_contribution
    self.conversation = contribution.conversation
  end
  scenario "Contribution tool is hidden by default", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # Then I should not see the contribution tool
    contrib.should_not be_visible
  end

  scenario "Contribution tool appears when a user posts to a conversation", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to button
    contrib.post_to_link.click

    # Then I should see the contribution tool
    contrib.should be_visible
  end

  scenario "Contribution tool appears when a user responds to a root-level contribution", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the respond-to button
    contrib.respond_to_link(contribution).click

    # Then I should see the contribution tool
    contrib.should be_visible
    contrib.should be_within_container convo_page.contribution_subthread(contribution)
  end
 
  scenario "Contribution tool appears when a user responds to a child contribution", :js => true do

    # Given a child contribution exists
    child = Factory.create(:contribution,
                           :override_confirmed => true,
                           :conversation => conversation,
                           :parent => contribution)

    # Given I am on a conversation node permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_node(conversation, child)
    sleep(1)

    contrib = ContributionTool.new(page)

    # When I click on the respond-to button
    contrib.respond_to_link(child).click     # need to see if the child is available to be clicked

    # Then I should see the contribution tool
    contrib.should be_visible

    # And it will appear as the last list element
    contrib.should be_within_container convo_page.contribution_subthread(contribution)
  end

  scenario "Contribution tool appears below all other contributions in the same thread", :js => true do
    contributions = create_some_nested_contributions

    contributions.each do |contribution|
      # Given I am on a conversation node permalink page
      convo_page = ConversationPage.new(page)
      convo_page.visit_node(conversation, contribution)
      sleep(2)
      contrib = ContributionTool.new(page)

      # When I click on the respond-to button
      contrib.respond_to_link(contribution).click

      # Then I should see the contribution tool
      contrib.should be_visible

      # And it will appear as the last list element
      contrib.should be_within_container convo_page.contribution_subthread(contribution)
    end
  end

  scenario "Contribution tool has all required elements", :js => true do
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    contrib.post_to_link.click
    contrib.content_field.should_not be_visible
    contrib.wysiwyg_editor.should be_visible
    contrib.add_url_link.should be_visible
    contrib.url_field.should_not be_visible
    contrib.add_file_link.should be_visible
    contrib.file_field.should_not be_visible
    contrib.submit_button.should be_visible
    contrib.cancel_link.should be_visible
    contrib.add_url_link.click
    contrib.url_field.should be_visible
    contrib.cancel_adding_url
    contrib.add_file_link.click
    contrib.file_field.should be_visible
 end

  scenario "Cancelling a contribution", :js => true do
    # NOTE: This test occationally has timing issues

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click

    # Then I should see the contribution tool
    contrib.should be_visible

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the Cancel link
    contrib.cancel_link.click

    # Then I should not see the contribution tool
    contrib.should_not be_visible
  end

  scenario "Posting only a comment", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
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
    contrib.should have_link(logged_in_user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting only a url", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click

    # When I click the 'Add a link...' link
    contrib.add_url url
    # And I press the submit button
    contrib.submit_button.click

    # Then I should see a link to my url
    contrib.should have_css("a[href='#{url}']")

    # And I should see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting only a file is not allowed", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click

    contrib.add_file file_path

    # And I press the submit button
    contrib.submit_button.click

    # And I should still see the contribution tool
    contrib.should be_visible

  end

  scenario "Posting a comment with a url", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    # When I click the 'Add a link...' link
    contrib.add_url url

    # And I press the submit button
    contrib.submit_button.click

    # Then I should see my contribution
    convo_page.should have_content(content)

    # Then I should see a link to my url
    contrib.should have_css("a[href='#{url}']")

    # Then I should see a link to my profile
    contrib.should have_link(logged_in_user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  scenario "Posting a comment with a file", :js => true do

    # Given I am on a conversation permalink page
    convo_page = ConversationPage.new(page)
    convo_page.visit_page(conversation)
    contrib = ContributionTool.new(page)

    # When I click on the post to conversation button
    contrib.post_to_link.click

    # When I fill in the content field
    contrib.fill_in_content_field(content)

    contrib.add_file file_path
    # And I press the submit button
    contrib.submit_button.click

    # Then I should see my contribution
    convo_page.should have_content(content)

    # Then I should see a link to my profile
    contrib.should have_link(logged_in_user.name)

    # And I should not see the contribution tool
    contrib.should_not be_visible

  end

  def conversation= convo
    @conversation = convo
  end
  def conversation
    @conversation
  end

  def create_some_nested_contributions
    contributions = []
    2.times { contributions << create_subcontribution_for(contribution)}
    2.times { contributions << create_subcontribution_for(contributions.first)}
    contributions
  end
end
