require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Managed Issue Page", %q{
  As a site visitor
  I want to view a static page
  So I can read the content
} do

  describe "visitng a managed issue show page" do

    scenario "and the page exists" do
      # Given an existing managed issue
      # And an existing managed issue page
      # And the page is the index for the issue
      # When I visit the issue page
      # Then I should be on the page
      # And I should see the page content
      issue = Factory.create(:managed_issue)
      index_page = Factory.create(:managed_issue_page, issue: issue)
      issue.index = index_page
      issue.save
      visit issue_path(issue)
      should_be_on issue_path(issue)
      page.should have_content index_page.template
    end

    scenario "and the page does not exit" do
      # Given an existing managed issue
      # And the issue does not have an index page
      # When I visit the issue page
      # Then I should be on the page
      # And I should the standard issue page
      issue = Factory.create(:managed_issue)
      visit issue_path(issue)
      should_be_on issue_path(issue)
      page.should have_content issue.name
    end

  end

  describe "visiting a managed issue page" do

    scenario "and the page exists" do
      # Given an existing managed issue
      # And an existing managed issue page
      # When I visit the page page
      # Then I should be on the page
      # And I should see the page content
      issue = Factory.create(:managed_issue)
      issue_page = Factory.create(:managed_issue_page, issue: issue)
      visit issue_page_path(issue, issue_page)
      should_be_on issue_page_path(issue, issue_page)
      page.should have_content issue_page.template
    end

    scenario "and the page does not exit" do
      # Given an existing managed issue
      # And the issue does not have any pages
      # When I visit a page page
      # Then I should be on the issue page
      # And I should see the standard issue page
      issue = Factory.create(:managed_issue)
      visit issue_page_path(issue, 'does-not-exist')
      should_be_on issue_path(issue)
      page.should have_content issue.name
    end

    scenario "and the issue does not exit" do
      # Given no existing managed issues
      # When I visit a page page
      # Then I should be on the issue index page
      visit issue_page_path('does-not-exist', 'does-not-exist')
      should_be_on issues_path
    end

  end

end
