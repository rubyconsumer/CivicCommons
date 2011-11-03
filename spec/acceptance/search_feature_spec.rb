require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Search the web site", %q{
  As a user of The Civic Commons
  I want to search
  So that I can find an issue, conversation or person I am interested in
} do
  let(:henry_ford)           {Factory.create(:normal_person, :first_name => "Henry", :last_name => "Ford")}
  let(:russell_anderson)      {Factory.create(:normal_person, :first_name => "Russell", :last_name => "Anderson")}
  let(:community_page)      {CommunityPage.new(page)}
  let(:conversation_page)   {ConversationPage.new(page)}
  let(:conversations_page)  {ConversationsPage.new(page)}
  let(:issue_page)          {IssuePage.new(page)}
  let(:issues_page)         {IssuesPage.new(page)}
  let(:search_results_page) {SearchResultsPage.new(page)}

  scenario "Search Filter for the conversations page" do
    # Given I am on the conversation page
    conversations_page.visit
    # When I enter a search query
    conversations_page.fill_in 'q', :with => 'search term here'
    # And I press search button
    conversations_page.click_link_or_button 'Search'
    # Then I should be redirected to the search results page
    page.current_path.include?(search_results_page.path).should be_true
    # And I should see 'Conversation' as the highlighted filter
    search_results_page.has_filter_selected?('Conversations').should be_true
  end

  scenario "Search Filter for a conversation page" do
    # Given a conversation
    conversation = Factory.create(:conversation)
    # And I am on the conversation page
    conversation_page.visit_page(conversation)
    # When I enter a search query
    conversations_page.fill_in 'q', :with => 'search term here'
    # And I press search button
    conversations_page.click_link_or_button 'Search'
    # Then I should be redirected to the search results page
    page.current_path.include?(search_results_page.path).should be_true
    # And I should see 'Conversation' as the highlighted filter
    search_results_page.has_filter_selected?('Conversations').should be_true
  end

  scenario "Search Filter for the community page" do
    # Given the users:
    henry_ford
    russell_anderson
    # and I am on the community page
    community_page.visit_page
    # When I enter a search query
    community_page.fill_in 'q', :with => 'search term here'
    # And I press search button
    community_page.click_link_or_button 'Search'
    # Then I should be redirected to the search results page
    page.current_path.include?(search_results_page.path).should be_true
    # And I should see 'Community' as the highlighted filter
    search_results_page.has_filter_selected?('Community').should be_true
  end

  scenario "Search Filter for the issues page" do
    # Given I am on the issues page
    issues_page.visit
    # When I enter a search query
    issues_page.fill_in 'q', :with => 'search term here'
    # And I press search button
    issues_page.click_link_or_button 'Search'
    # Then I should be redirected to the search results page
    page.current_path.include?(search_results_page.path).should be_true
    # And I should see 'Issues' as the highlighted filter
    search_results_page.has_filter_selected?('Issues').should be_true
  end

  scenario "Search Filter for an issue page" do
    # Given a issue
    issue = Factory.create(:issue)
    # And I am on the issue page
    issue_page.visit_page(issue)
    # When I enter a search query
    issue_page.fill_in 'q', :with => 'search term here'
    # And I press search button
    issue_page.click_link_or_button 'Search'
    # Then I should be redirected to the search results page
    page.current_path.include?(search_results_page.path).should be_true
    # And I should see 'Issues' as the highlighted filter
    search_results_page.has_filter_selected?('Issues').should be_true
  end

=begin
### commented out because the test always fails when sunspot is invoked at any point
  scenario "User can search The Civic Commons" do
    # Given I am on the home page
    visit root_path
    # And I type what I want to find into the top search box
    fill_in('q', :with => 'town')
    # And I don't filter by conversation, issue or community
    # When I click search
    click_button('Search')

    # I should be sent to the results page
    should_be_on search_results_path

    # Where I will see results of my search
  end
=end
=begin
# sunspot_test way
  describe "searching", :search => true do
    it 'returns conversation results' do
      conversation = Factory(:conversation, :title => "Townhall is the talk")
      Sunspot.commit
      Conversation.search { keywords "talk"}.results.should == [conversation]
    end
  end
=end

end
