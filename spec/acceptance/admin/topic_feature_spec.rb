require 'acceptance/acceptance_helper'

WebMock.allow_net_connect!
Capybara.default_wait_time = 10


feature "Topic Admin", %q{
  In order to Administer Topics
  As a an Admin user
  I want to access the topic admin feature
} do


  let(:admin_topics_page){ AdminTopicsPage.new(page)} 
  let(:admin_new_topic_page){AdminNewTopicPage.new(page)}
  let(:admin_edit_topic_page){AdminEditTopicPage.new(page)}
    

  scenario "creating a topic" do
    goto_admin_page_as_admin
    follow_add_topic_link
    fill_in_topic_form
    submit_topic_form
     
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

    admin_topics_page.click_edit_on_a_topic(@topic)
    admin_edit_topic_page.fill_in_topic_fields(:name=>'Changed Name Here')
    
    # And I press submit
    admin_edit_topic_page.click_update_topic
    
    # Then I should be redirected to the show page
    page.current_path.should == admin_topic_path(@topic)
    
    # And I should see the name changed
    admin_topics_page.should contain 'Changed Name Here'
  end
  
  scenario "creating and validating a topic" do
    create_topic name: "bla"

    goto_admin_page_as_admin
    follow_topics_link
    
    # And I click on Add Topic
    admin_topics_page.click_new_topic
    
    # and I just click submit without entering anything
    admin_new_topic_page.click_create_topic
    
    # Then I should see validation error
    admin_new_topic_page.should contain 'error'
    
    # Topic should not have been created
    Topic.count.should == 0
  end
  

end

