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

  scenario "Retrieve all subscriptions for a user" do

    # When I visit the person's subscriptions page
    api_page.visit_subscriptions(user)

    # Then I should receive a response
    api_page.body.should_not be_empty

    # Then the response should be valid JSON
    data = api_page.parse_json_body
    data.should_not be_nil

    # Then the response should contain two subscriptions
    data.should have(2).items

    # Then the response should include the necessary information
    data.each do |sub|

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

  scenario "Retrieve subscribed conversations for a user" do

    # When I visit the person's subscriptions page
    api_page.visit_subscriptions(user, 'conversation')

    # Then I should receive a response
    api_page.body.should_not be_empty

    # Then the response should be valid JSON
    data = api_page.parse_json_body
    data.should_not be_nil

    # Then the response should contain one subscription
    data.should have(1).items

    # Then the response should include the necessary information
    data[0]['id'].should == convo.id
    data[0]['title'].should == convo.title
    data[0]['url'].should == conversation_url(convo)
    
  end

  scenario "Retrieve subscribed issues for a user" do

    # When I visit the person's subscriptions page
    api_page.visit_subscriptions(user, 'issue')

    # Then I should receive a response
    api_page.body.should_not be_empty

    # Then the response should be valid JSON
    data = api_page.parse_json_body
    data.should_not be_nil

    # Then the response should contain one subscription
    data.should have(1).items

    # Then the response should include the necessary information
    data[0]['id'].should == issue.id
    data[0]['title'].should == issue.name
    data[0]['url'].should == issue_url(issue)
    
  end

  scenario "Retrieve subscriptions for nonexistent user" do

    # When I ask for subscriptions for a nonexistent user 
    api_page.visit_subscriptions(Person.maximum('id') + 1000)
    
    # Then I should receive a 404 Not Found response
    api_page.status_code.should == 404

  end

  scenario "Retrieve subscriptions for user without subscriptions" do

    # When I ask for subscriptions for a user without subscriptions
    user = Factory.create(:registered_user)
    api_page.visit_subscriptions(user)
    
    # Then I should receive a 200 OK response
    api_page.status_code.should == 200

    # Then the response should be valid JSON
    data = api_page.parse_json_body
    data.should_not be_nil

    # Then the response should contain no subscription
    data.should have(0).items

  end

end
