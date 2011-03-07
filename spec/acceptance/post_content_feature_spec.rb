# example -- http://timelessrepo.com/bdd-with-rspec-and-steak

require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

require 'pp'

feature "Post Content Item", %q{
  As an administrator,
  I want to post content a content item
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
      visit content_items_root_path
      should_be_on content_items_root_path

    end
end
