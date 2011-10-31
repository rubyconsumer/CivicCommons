require 'acceptance/acceptance_helper'



feature "Topic Admin", %q{
  In order to Administer Topics
  As a an Admin user
  I want to access the topic admin feature
} do

    

  scenario "creating a topic" do
    goto_admin_page_as_admin
    follow_add_topic_link
    fill_in_topic_form
    submit_form
     
    submitted_topic.should exist_in_the_database
    the_page_im_on.should be_for_the submitted_topic
  end
   
  scenario "deleting a topic", :js => true do
    create_topic name: "bla"

    goto_admin_page_as_admin
    follow_topics_link
    delete_topic topic

    topic.should be_removed_from page
    topic.should have_been_removed_from_the_database

  end
  
  scenario "updating a topic" do
    create_topic name: "bla"

    goto_admin_page_as_admin
    follow_topics_link

    click_edit_link_for topic
    
    fill_in_topic_form name: 'bork bork bork'
    submit_form
    

    topic.name.should == "bork bork bork"
    page.should contain "bork bork bork"
    the_page_im_on.should be_for_the topic
    
    
  end
  
  scenario "submitting an empty topic" do

    goto_admin_page_as_admin
    follow_topics_link
    
    follow_add_topic_link
    
    submit_form
    the_page_im_on.should have_an_error 
    database.should_not have_any :topics
  end
  

end

