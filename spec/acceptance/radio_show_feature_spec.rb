require 'acceptance/acceptance_helper'

feature " RadioShow Index", %q{
  As an visitor
  When I want to see radioshows
  I will be able view them
} do
  background do
    database.create_radio_show
  end
  
  def given_blog_posts 
    database.destroy_all_content_items
    database.create_blog_post :title => 'blog one'
    database.create_blog_post :title => 'blog two'
    database.create_blog_post :title => 'blog three'
  end

  scenario "Seeing the radioshows with latest blog posts" do
    given_blog_posts
    goto :radio_show
    page.should have_content "blog one"
    page.should have_content "blog two"
    page.should have_content "blog three"
  end
end