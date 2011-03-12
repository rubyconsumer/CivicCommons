# example -- http://timelessrepo.com/bdd-with-rspec-and-steak

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
      # When I visit the content items page
      # Then I should be on the content items page
      # And I should see a list of content items

      visit admin_root_path(admin)
      visit admin_content_items_path
      should_be_on admin_content_items_path
#      page.should have_content('Blog Post 1')

    end

    scenario "Administrator can create a new conent item" do
      # Given I am on the content item creation page
      # And I have selected a content type
      # And I have entered valid content data
      # When I press the “Create Content Item” button
      # Then the content item should be created
      # And I should be on the content item summary page
      # And I should see the success message
      # And I should see my name as the author
      
    end
end
