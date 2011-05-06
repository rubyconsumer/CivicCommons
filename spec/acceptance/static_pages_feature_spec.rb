require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Static Page", %q{
  As a site visitor
  I want to view a static page
  So I can read the content
} do

  describe "visitng a static page" do

    scenario "the page exists" do
      # Given an existing static FAQ page
      # When I visit the FAQ page
      # Then I should be on the FAQ page
      # And I should see the FAQ text
      @static_page = Factory.create(:content_template, name: 'FAQ', cached_slug: 'faq')
      visit page_path(@static_page)
      should_be_on page_path(@static_page)
      page.should have_content(@static_page.template)
    end

    scenario "the page does not exit" do
      # Given no existing static pages
      # When I visit the FAQ page
      # Then I should be on the home page
      ContentTemplate.delete_all
      visit page_path('faq')
      should_be_on root_path
    end

  end

end
