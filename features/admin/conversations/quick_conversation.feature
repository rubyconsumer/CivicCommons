@wip
Feature:  Adding a Quick Conversation
  In order to start a new conversation with only one TLC
  As an Admin
  I want to be able to create a conversation without a transcript

  Background:
    Given I am logged in as an admin
  
  Scenario: Navigating to the new quick conversation page
    Given I am on the admin home page
    When I click "Add Simple Conversation"
    Then I should be on the new simple conversation page

  Scenario: Creating a simple conversation
    Given I am on the new simple conversation page
    When I fill in the form with:
      | field          |  value                                   |
      | title          | Test Simple Conversation                 |
      | summary        | Summary for testing simple conversations |
      | enter zip code | 44118                                    |
    And I add a file as the Top Level Contribution
    When I click "Create Conversation"
    Then I should be on the admin conversation page
    And I should see a message "Thank You for Creating a Simple Conversation"
