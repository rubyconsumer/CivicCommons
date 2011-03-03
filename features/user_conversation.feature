Feature:
  As a normal user
  I want to create a conversation and
  invite others to join

  Scenario: User creates a user-conversation
    Given I am on the conversation index page
    Then I will see a "Create a Conversation" link

    Given I am on the home page
    Then I will see a "Create a Conversation" link

    Given I am logged in
    And I am on the home page
    When I select the "Create a Conversation" link
    Then I will be on the responsibilities page
    And I will see the responsibilities verbiage
    And I will see an "I agree, continue" button
    And I will see a "Cancel" link
    When I visit the conversation creation page directly
    Then I will be redirected to the responsibilities page

    Given that I am on the responsibilities page
    When I select the "Cancel" link
    Then I will be on the home page
    And no conversation will be created

    Given I am not logged in
    And that I am on the responsibilities page
    When I press the "I agree, continue" button
    Then I will be on the login page

    Given I am logged in
    And that I am on the responsibilities page
    When I press the "I agree, continue" button
    Then I will be on the conversation creation page

    Given that I am on the conversation creation page
    Then I should see a "Title" text box
    And I should see an Issues selection field
    And I should see an image upload field
    And I should see a "Summary" text area
    And I should see a "Create Conversation" submit button
    And I should see a "Cancel" link

    Given that I am on the conversation creation page
    When I select the "Cancel" link
    Then I will be on the home page
    And no conversation will be created

    Given that I am on the conversation creation page
    And I have entered valid conversation data:
      | Title             | Some Conversation                 |
      | Summary           | This is a great new conversation. |
      | Zip Code          | 48105                             |
      | Comment           | This is a sweet new comment.      |
    When I press the "Create Conversation" button
    Then the conversation should be created
    And I should be on the invite participants page
    And I should see the success message
    And I should see the conversation box and image
    And I should see an "Invite Participants" submit button
    And I should see a "No Thanks" link

    Given that I am on the invite participants page
    When I select the "No Thanks" link
    Then I should be on the conversation page for my conversation
    And no invitations should be sent
