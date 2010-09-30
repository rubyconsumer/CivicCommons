Feature:
  As a People Aggregator developer
  I want to be able to retrieve conversations a user is participating in
  So that I can display the details on the user's profile page

  Background:
    Given a registered user:
      | First Name | Joe           |
      | Last Name  | Test          |
      | Email      | joe@test.com  |
      | Zip        | 44444         |
      | Password   | abcd1234      |

  Scenario: Retrieve one conversation in which the user is participating
    Given a conversation:
      | Title       | This is a test conversation |
      | Image       | imageAttachment.png         |
      | Summary     | Test conversation           |
      | Zip Code    | 44111                       |
    And I have a comment on the conversation
    When I ask for conversations with URL:
    """
    /api/joe@test.com/conversations
    """
    Then I should receive a response:
    """
    [
      {
        "title": "This is a test conversation",
        "image": "http://s3.amazonaws.com/cc-dev/images/original/imageAttachment.png",
        "summary": "Test conversation",
        "participant_count": 2,
        "contribution_count": 1
      }
    ]
    """


