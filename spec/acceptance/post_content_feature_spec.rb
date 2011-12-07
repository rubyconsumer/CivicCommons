require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Post Content Item", %q{
  As an administrator,
  I want to post a content item
  So that I can show information on the web site without starting a conversation or issue
} do

    let :content do
      Factory :content_item
    end

    background do
      goto_admin_page_as_admin
    end

    scenario "Administrator can see the list of existing content items" do
      visit admin_content_items_path(content)
      should_be_on admin_content_items_path
      page.should have_content(content.title)
    end

    scenario "Delete a content item" do
      visit admin_content_items_path(content)
      click_link('Delete')
      should_be_on admin_content_items_path
      page.should have_content("Successfully deleted content item")
    end

    scenario "Administor does not fill in required fields when writing a new content item" do
      visit new_admin_content_item_path
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "External link is a required field for a content item type that is NewsItems" do

      visit new_admin_content_item_path
      select('NewsItem', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "External link is not a required field for a BlogPost" do

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that blog post')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
    end

    scenario "Create a new content item" do

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
    end

    scenario "New content item is associated with the currently logged in author" do

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content("has been created")
      page.should have_content(logged_in_user.first_name + " " + logged_in_user.last_name)
    end

    scenario "New content item is associated with the selected author" do
      second_admin = Factory :admin_person
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

      visit new_admin_content_item_path
      select('NewsItem', :from => 'content_item_content_type')
      fill_in('content_item_external_link', :with => 'my-invalid url ')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Create Content item')
      page.should have_content("still missing some important information:")
    end

    scenario "New content item is created with today's publish date as the default" do
      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Blog Post')
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      should_be_on admin_content_item_path(ContentItem.last)
      page.should have_content(Date.parse(Date.today.to_s).strftime("%B %d, %Y"))
    end

    scenario "Author can set the publish date of the content item" do

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

      visit new_admin_content_item_path
      select('BlogPost', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => content.title)
      fill_in('content_item_body', :with => 'This blog post is about that radio show')
      click_button('Create Content item')
      page.should have_content("has already been taken")
    end

    scenario "See the edit content item page" do
      visit admin_content_items_path(content)
      click_link("Edit")
      should_be_on edit_admin_content_item_path(content)
    end

    scenario "Edit content item" do
      visit edit_admin_content_item_path(content)
      select('RadioShow', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => 'First Radio Show')
      fill_in('content_item_body', :with => 'This radio show is about that radio show')
      click_button('Update Content item')
      should_be_on admin_content_items_path
    end

    scenario "Edit content item without required fields" do
      visit edit_admin_content_item_path(content)
      select('RadioShow', :from => 'content_item_content_type')
      fill_in('content_item_title', :with => '    ')
      fill_in('content_item_body', :with => '    ')
      click_button('Update Content item')
      page.should have_content("still missing some important information")
    end

    scenario "Title is used as slug" do
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
