require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "API Subscriptions", %q{
  As an API client
  I want to be able to retrieve a user's subscriptions
  So that I encourage others to participate and show how people are using the system
} do

  # Given a registered user
  let :user do
    Factory :registered_user
  end

  # Given a valid conversation
  let :convo do
    Factory :conversation
  end

  # Given a valid issue
  let :issue do
    Factory :issue
  end

  let :api_page do
    ApiPage.new(page)
  end

  background do
    # Given the registered user is following the valid conversation
    # Given the registered user is following the valid issue
    # Given the registered user is logged in
    Factory.create(:conversation_subscription, :person => user, :subscribable => convo)
    Factory.create(:issue_subscription, :person => user, :subscribable => issue)
    LoginPage.new(page).sign_in(user)
  end

  scenario "Retrieve all subscriptions" do

    # When I visit the person's subscriptions page
    api_page.visit_subscriptions(user)

    # The I should receive a response
    api_page.body.should_not be_empty

    # Then I should be valid JSON
    lambda { @data = JSON.parse(api_page.body.strip) }.should_not raise_exception

    # Then the response should contain two subscriptions
    @data.should have(2).items

    # Then the response should include the necessary information
    @data.each do |sub|

      if sub['type'] == 'issue'
      
        sub['id'].should == issue.id
        sub['title'].should == issue.name
        sub['url'].should == issue_url(issue)

      elsif sub['type'] == 'conversation'
      
        sub['id'].should == convo.id
        sub['title'].should == convo.title
        sub['url'].should == conversation_url(convo)
      
      else
        
        flunk 'Invalid subscription type'
      end
    
    end
    
  end

#    Then I should receive the response:
#    """
#    [
#      {
#        "id": 2,
#        "title": "Democrats Upset About Recent Election Results",
#        "url": "http://www.example.com/issues/2",
#        "type": "issue"
#      },
#      {
#        "id": 3,
#        "title": "Obamacare Pushes on Through Despite Antagonists",
#        "url": "http://www.example.com/conversations/3",
#        "type": "conversation"
#      },
#      {
#        "id": 2,
#        "title": "Understanding The Latest Health Care Changes",
#        "url": "http://www.example.com/conversations/2",
#        "type": "conversation"
#      }
#    ]
#    """
    #pending
  #end

  scenario "Retrieve subscribed conversations" do
#    When I ask for conversations the person with ID 12 is following
#    Then I should receive the response:
#    """
#    [
#      {
#        "id": 3,
#        "title": "Obamacare Pushes on Through Despite Antagonists",
#        "url": "http://www.example.com/conversations/3"
#      },
#      {
#        "id": 2,
#        "title": "Understanding The Latest Health Care Changes",
#        "url": "http://www.example.com/conversations/2"
#      }
#    ]
#    """
    pending
  end

  scenario "Retrieve subscribed issues" do
#    When I ask for issues the person with ID 12 is following
#    Then I should receive the response:
#    """
#    [{
#      "id": 2,
#      "title": "Democrats Upset About Recent Election Results",
#      "url": "http://www.example.com/issues/2"
#    }]
#    """
    pending
  end

  scenario "Retrieve subscriptions for non-existant user" do
#    When I ask for subscriptions for the person with ID 1099932
#    Then I should receive a 404 Not Found response
    pending
  end

end
