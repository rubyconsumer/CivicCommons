@wip
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
      | Moderator   | Test Moderator              |
      | Zip Code    | 44111                       |
    And I have a comment on the conversation
    When I ask for conversations with URL:
    """
    /api/joe@test.com/conversations
    """
    Then I should receive the response:
    """
    {
      {
        "Title": "This is a test conversation",
        "Image": "http://s3.amazonaws.com/cc-dev/images/6/normal/imageAttachment.png",
        "Summary": "Test conversation",
        "Started At": "9/15/2010 10:58 AM",
        "Finished At": "9/15/2010 12:00 PM",
        "Moderator": "Test Moderator",
        "Zip Code": "44111"
      }
    }
    """


