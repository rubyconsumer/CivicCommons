Feature:
  As a paranoid developer
  I want to make sure user profiles are linking properly
  So that users don't see an error page

  Scenario: viewing blog page
    Given the necessary Civic Commons admin users
    And I am on the blog page
    Then I should see correct links to user profiles
