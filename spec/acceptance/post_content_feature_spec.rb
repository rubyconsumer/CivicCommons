# example -- http://timelessrepo.com/bdd-with-rspec-and-steak
#save_and_open_page

require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

require 'pp'

feature "Post Content Item", %q{
  As an administrator,
  I want to post a content item
  So that I can show information on the web site without starting a conversation or issue
} do

    let :user do
      Factory :registered_user
    end

    let :admin do
      Factory :admin_person
    end

    let :content do
      Factory :content_item
    end

    background do
      # Given I am logged in as an administrator
      LoginPage.new(page).sign_in(admin)
    end

    scenario "Administrator can get to administration page" do
      # When I visit the admin page
      # Then I should be on the admin page

      visit admin_root_path(admin)
      should_be_on admin_root_path
    end

    scenario "Administrator can see the list of existing content items" do
      # Given I am on the administration page
      # And there is at least one existing content item
      # When I visit the content items page
      # Then I should be on the content items page
      # And I should see a list of content items

      visit admin_root_path(admin)
      visit admin_content_items_path(content)
      should_be_on admin_content_items_path
      page.should have_content('Untyped post 1')
    end

    scenario "Administor does not fill in required fields when writing a new content item" do
      # Given I am on the content creation page
      # And I have not filled in any required fields
      # When I click submit
      # Then I should see an error message

      visit new_admin_content_item_path
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "Administrator can create a new content item" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the success message

      visit new_admin_content_item_path
      select('RadioShow', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Radio Show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(content.id - 1)
      page.should have_content("Your content item has been created!")
    end
end
