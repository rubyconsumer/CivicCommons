module CivicCommonsDriver
  include Rails.application.routes.url_helpers
  include Capybara
  
  

  def attachments_path
    File.expand_path(File.dirname(__FILE__) + '/attachments')
  end
  def login_as_admin
    user = Factory.create(:admin_person, declined_fb_auth: true)
    visit new_person_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
  def login
    user = Factory.create(:registered_user, declined_fb_auth: true)
    visit new_person_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
  def goto screen
    rails_route = { :admin_page => :admin_root }
    
    visit url_for rails_route[screen]
  end

  def select_topic topic
    check topic  
  end

  def submit_a_topic
    
  end

  def fill_name_with(value)
    fill_in 'Name', with: value
  end
  
  def fill_summary_with(value)
    fill_in 'Summary', with: value
  end

  def attach_image file_name
    attach_file 'issue[image]', File.join(attachments_path, file_name) 
  end

  def submit_issue
    click_button 'Create Issue'
  end
  def create_topic(attributes={}) 
    @topic = Factory.create :topic, attributes
  end
  
  def delete_topic topic
    within "tr[data-topic-id='#{topic.id}']" do
      click_link "Delete"
    end
    page.driver.browser.switch_to.alert.accept
  end

  def topic
    @topic.instance_eval do
      def removed_from? page
        page.has_no_css? "tr[data-topic-id='#{id}']"
      end

      def has_been_removed_from_the_database?
        !Topic.exists? id
      end
    end
    @topic
  end


  def goto_admin_page_as_admin
    logged_in_as_admin
    visit '/admin'
  end
  def follow_topics_link
    click_link 'Topics'
  end
  def follow_add_topic_link
    click_link 'Add Topic'
  end

  def fill_in_topic_form
    fill_in 'Name', :with => "WOOHOO!"
  end

  def submit_topic_form
    click_button "Create Topic"
  end

  def submitted_topic
    Topic.find_by_name "WOOHOO!"
  end

  def the_page_im_on
    def page.for_the?(topic)
      current_path.should == "/admin/topics/#{topic.id}"
    end
    def page.the_invite_a_friend_page_for_the? conversation
      has_content?("Invite a Friend") and has_content? conversation.title
    end
    page
  end

end


Rspec.configuration.include CivicCommonsDriver, :type => :acceptance
