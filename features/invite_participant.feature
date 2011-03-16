Feature:
  In order to create an active and intelligent conversation
  As a logged in user,
  I want to invite additional people to a conversation

  Scenario: User sees the 'Send Invitations' button
    Given I am signed in
    When I am on the conversation page
    Then I will see an "Send Invitations" button

  Scenario: User does not see 'Send Invitations' button
    Given that I am not logged in
    When I am on the conversation page
    Then I will see an "Send Invitations" button
    And I will see the "Log in to your account" button

  Scenario: User goes to invitation page
    Given I am signed in
    And I am on the conversation page
    When I click the "Send Invitations" button
    Then I will be on the invitation page

  Scenario: User sees invitation page
    Given I am signed in
    And that I am on the invitation page
    Then I should see a textarea for invitee email addresses
    And I should see an "Send" button

  Scenario: User click Send link with empty textbox
    Given I am signed in
    And that I am on the invitation page
    And the invitee textarea is empty
    When I click the "Send" button
    Then I should see an error message
    And they should receive no emails

  Scenario: User clicks Send link with valid emails
    Given I am signed in
    And that I am on the invitation page
    When I enter one or more comma-delimited email addresses in the invitee textarea
    And I click the "Send" button
    Then I should be on the conversation page
    And I should see a success message
    And "alpha@example.com" should receive an email with subject "invite.*conversation"
    And "bravo@example.com" should receive an email with subject "invite.*conversation"
    And "charlie@example.com" should receive an email with subject "invite.*conversation"
