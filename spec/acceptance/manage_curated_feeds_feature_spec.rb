require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Manage curated feeds", %q{
  As an administrator
  I want to manage curated feeds
  So I can
} do
  
  let :feed_page do
    AdminCuratedFeedPage.new(page)
  end

  background do
    # Given I am logged in as an administrator
    logged_in_as_admin   
  end

  describe "create a new curated feed" do

    scenario "with valid data" do
      # Given I am on the create curated feed page
      # And I enter a valid title
      # And I enter a valid description
      # When I click the submit button
      # Then I should be on the curated feed index page
      # And I should see the new feed
      visit new_admin_curated_feed_path
      feed_page.fill_in_title('New feed title')
      feed_page.fill_in_description('This is a really cool new feed...')
      feed_page.submit
      should_be_on admin_curated_feeds_path
      page.should have_content('New feed title')
    end

    scenario "with invalid data" do
      # Given I am on the create curated feed page
      # When I click the submit button
      # Then I am should be on the curated feeds page
      # And I should see an error message
      visit new_admin_curated_feed_path
      feed_page.submit
      should_be_on admin_curated_feeds_path
      page.should have_content('error')
    end

  end

  describe "manage curated feed items" do

    # Given a valid curated feed
    let :feed do
      Factory.create(:curated_feed)
    end

    let :feed_params do
      Factory.attributes_for(:curated_feed_item)
    end

    scenario "add a valid feed item" do
      # Given I am on the curated feed #show page
      # When I enter a valid URL
      # And I submit the form
      # Then I should be on the curated feed #show page
      # And I should see the feed item
      visit admin_curated_feed_path(feed)
      feed_page.fill_in_item_url(feed_params[:original_url])
      feed_page.submit_item
      should_be_on admin_curated_feed_path(feed)
      feed_page.has_item_link?(feed, 1)
    end

    scenario "delete a feed item" do
      # Given an existing feed item
      # When I am on the curated feed #show page
      # When I select the delete link
      # Then I should be on the curated feed #show page
      # And I should not see the feed item
      item = Factory.create(:curated_feed_item, curated_feed: feed)
      visit admin_curated_feed_path(feed)
      feed_page.delete_item(item)
      should_be_on admin_curated_feed_path(feed)
      ! feed_page.has_item_link?(feed, item)
    end

    scenario "update a feed item with valid data" do
      # Given an existing feed item
      # When I am on the curated feed #show page
      # And I select the edit link
      # Then I should be on the feed item edit page
      # When I enter a valid url
      # And I submit the form
      # Then I should be on the curated feed #show page
      # And I should see the feed item
      item = Factory.create(:curated_feed_item, curated_feed: feed)
      visit admin_curated_feed_path(feed)
      feed_page.edit_item(item)
      should_be_on edit_admin_curated_feed_item_path(feed, item)
      feed_page.fill_in_item_url('http://www.yahoo.com')
      feed_page.submit_item
      should_be_on admin_curated_feed_path(feed)
      feed_page.has_item_link?(feed, 1)
    end

  end

end
