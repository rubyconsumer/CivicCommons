require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

WebMock.allow_net_connect!
Capybara.default_wait_time = 10


feature "Topic Admin", %q{
  In order to Administer Topics
  As a an Admin user
  I want to access the topic admin feature
} do

  def given_logged_in_as_admin
    @user = logged_in_as_admin
  end
  
  def given_an_existing_topic
    @topic = Factory.create(:topic,:name => 'Topic Name Here')
  end
  
  
  let(:admin_topics_page){ AdminTopicsPage.new(page)} 
  let(:admin_new_topic_page){AdminNewTopicPage.new(page)}
  let(:admin_edit_topic_page){AdminEditTopicPage.new(page)}
    

  scenario "See an option to add a topic on the admin site" do
    # Given that I am an admin    
    given_logged_in_as_admin
    
    # When I go to the admin page
    admin_topics_page.visit
    
    # Then I will see an option to add a survey
    admin_topics_page.should have_link 'Add Topic', :href => new_admin_topic_path
  end
  
  scenario "creating a topic" do
    # Given that I am an admin
    given_logged_in_as_admin
    
    # When I go to the admin page
    admin_topics_page.visit
    
    # And I click on Add Topic
    admin_topics_page.click_new_topic
    
    # and I entered the Topic name
    admin_new_topic_page.fill_in_topic_fields
    
    # and I click submit
    admin_new_topic_page.click_create_topic
    
    # Then I should be redirected to the show page
    page.current_path == admin_topic_path(Topic.last)
  end
  
  scenario "deleting a topic", :js => true do
    # Given I am an admin
    given_logged_in_as_admin
    
    # And a topic already exists
    given_an_existing_topic
    
    # And I am on the topic index page
    admin_topics_page.visit
    
    # When I click delete
    admin_topics_page.click_delete_on_a_topic(@topic)
    
    # Then I should not see the topic anymore
    admin_topics_page.should_not contain 'Topic Name Here'
    Topic.count.should == 0
  end
  
  scenario "updating a topic" do
    # Given I am an admin
    given_logged_in_as_admin
    
    # And a topic already exists
    given_an_existing_topic
    
    # And I am on the topic index page
    admin_topics_page.visit
    
    # When I click edit
    admin_topics_page.click_edit_on_a_topic(@topic)
    
    # And I change the name of topic into something else
    admin_edit_topic_page.fill_in_topic_fields(:name=>'Changed Name Here')
    
    # And I press submit
    admin_edit_topic_page.click_update_topic
    
    # Then I should be redirected to the show page
    page.current_path.should == admin_topic_path(@topic)
    
    # And I should see the name changed
    admin_topics_page.should contain 'Changed Name Here'
  end
  
  scenario "creating and validating a topic" do
    # Given that I am an admin
    given_logged_in_as_admin
    
    # When I go to the admin page
    admin_topics_page.visit
    
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
