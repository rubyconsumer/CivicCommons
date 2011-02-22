Feature:
  In order to create an active and intelligent conversation
  As a logged in user,
  I want to invite additional people to a conversation

  Scenario: User sees the 'Invite Participants' button
    Given I am signed in
    When I am on the conversation page
    Then I will see an 'Invite Participants' button

  Scenario: User does not see 'Invite Participants' button
    Given that I am not logged in
    When I am on the conversation page
    Then I will not see an 'Invite Participants' button

  Scenario: User goes to invitation page
    Given I am signed in
    And I am on the conversation page
    When I click the 'Invite Participants' button
    Then I will be on the invitation page

  Scenario: User sees invitation page
    Given I am signed in
    And that I am on the invitation page
    Then I should see a textarea for invitee email addresses
    And I should see a 'Send' button
    And I should see a 'Cancel' link

  Scenario: User clicks Cancel link
    Given I am signed in
    And that I am on the invitation page
    #And no emails have been sent
    When I click the cancel link
    Then I should be on the conversation page
    And they should receive no emails

  Scenario: User click Send link with empty textbox
    Given I am signed in
    And that I am on the invitation page
    And the invitee textarea is empty
    When I click the 'Send' button
    Then I should see an error message
    And they should receive no emails

  Scenario: User clicks Send link with valid emails
    Given I am signed in
    And that I am on the invitation page
    When I enter one or more comma-delimited email addresses in the invitee textarea
    And I click the 'Send' button
    Then I should be on the conversation page
    And I should see a success message
    And "alpha@example.com" should receive an email with subject "You've been invited to the Civic Commons!"
    And "bravo@example.com" should receive an email with subject "You've been invited to the Civic Commons!"
    And "charlie@example.com" should receive an email with subject "You've been invited to the Civic Commons!"
