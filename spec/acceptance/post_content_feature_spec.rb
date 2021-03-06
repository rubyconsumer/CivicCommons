require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

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

    let :second_admin do 
      Factory :admin_person
    end

    let :content do
      Factory :content_item
    end

    background do
      #EmbedlyService.stub!(:get_simple_embed).and_return(nil)
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
      page.should have_content(content.title)
    end

    scenario "Delete a content item" do
      # Given I am on the content items page
      # When I press the “Delete” link for a content item
      # And I confirm deletion
      # Then that content item should be deleted
      # And I should be on the content items page
      # And I should see the success message

      visit admin_content_items_path(content)
      click_link('Delete')
      should_be_on admin_content_items_path
      page.should have_content("Successfully deleted content item")
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

    scenario "External link is a required field for a content item type that is NewsItems" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have not entered an external url
      # When I press the “Create Content item” button
      # Then I should see an error message

      visit new_admin_content_item_path
      select('NewsItem', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "External link is not a required field for a BlogPost" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have not entered an external url
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the success message

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that blog post')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
    end

    scenario "Create a new content item" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the success message

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
    end

    scenario "New content item is associated with the currently logged in author" do
      # Given there is a second author
      # And I am on the content item creation page
      # And I have entered required content item fields
      # And I have left the Author selection as the default option
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the success message
      # And I should see my name as the author

      second_admin
      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
      page.should have_content(admin.first_name + " " + admin.last_name)
    end

    scenario "New content item is associated with the selected author" do
      # Given there is a second author
      # And I am on the content item creation page
      # And I have entered required content item fields
      # And I have selected an author other than me
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the success message
      # And I should see my name as the author

      second_admin
      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      select(second_admin.first_name + " " + second_admin.last_name, :from => 'content_item_person_id')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      page.should have_content("has been created")
      page.should have_content(second_admin.last_name)
    end

    scenario "New content item is saved with an external link" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have entered a valid url in the external link field
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the url I entered into the external link field

      visit new_admin_content_item_path
      select('NewsItem', :from => 'content_item_content_type')
      fill_in('content_item_external_link', :with => 'http://www.yahoo.com')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("http://www.yahoo.com")
    end

    scenario "Content item is not saved when external link is invalid" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have entered an invalid value for external url
      # When I press the “Create Content item” button
      # Then I should see an error message

      visit new_admin_content_item_path
      select('NewsItem', :from => 'content_item_content_type')
      fill_in('content_item_external_link', :with => 'my-invalid url ')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "New content item is created with today's publish date as the default" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have not edited the publish date (default value)
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see todays date as the publish date

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content(Date.parse(Date.today.to_s).strftime("%B %d, %Y"))
    end

    scenario "Author can set the publish date of the content item" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And I have edited the publish date to be tomorrow
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see tomorrow's date as the publish date

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      fill_in('content_item_published', :with => Date.tomorrow.strftime("%m/%d/%Y"))
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content(Date.parse(Date.tomorrow.to_s).strftime("%B %d, %Y"))
    end

    scenario "Title field must be unique" do
      # Given I am on the content item creation page
      # And there are existing content items
      # And I have entered required content item fields
      # And there is already an existing content item
      # And it has the same title as the one I entered
      # When I press the "Create Content item" button
      # Then I should see an error message

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => content.title)
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      page.should have_content("has already been taken")
    end

    scenario "See the edit content item page" do
      # Given I am on the content items page
      # When I press the “Edit” link for a content item
      # Then I should be on the edit content item page

      visit admin_content_items_path(content)
      click_link("Edit")
      should_be_on edit_admin_content_item_path(content)
    end

    scenario "Edit content item" do
      # Given: I am on the edit content item page
      # And I have populated all required fields
      # When I click “Update Content Item” button
      # Then that content item should be updated
      # And I should be on the content items page
      # And I should see a the success message

      visit edit_admin_content_item_path(content)
      select('RadioShow', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Update Content item')
      should_be_on admin_content_items_path
    end

    scenario "Edit content item without required fields" do
      # Given: I am on the edit content item page
      # And I have not populated
      # When I click “Update Content Item” button
      # Then that content item should not be updated
      # And I should be on the edit content item page
      # And I should see a the an error message

      visit edit_admin_content_item_path(content)
      select('RadioShow', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => '    ')
      fill_in('content_item_body', :with => '    ')
      click_button('Update Content item')
      page.should have_content("still missing some important information")
    end

    scenario "Title is used as slug" do
      # Given I am on the content item creation page
      # And I have entered required content item fields
      # And the url field is blank
      # When I press the “Create Content item” button
      # Then the content item should be created
      # And I should be on the view content item page
      # And I should see the title field with slugs in for the url
      
      title = 'First Blog Post'
      body = 'This blog post is about that blog post'
      slug = 'first-blog-post'

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => title)
      fill_in('content_item_body', :with => body)
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_link(title, :href => slug)
    end
end
