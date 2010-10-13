Feature:
  As a People Aggregator developer
  I want to be able to retrieve conversations a user is participating in
  So that I can display the details on the user's profile page

  Background:
    Given a registered user:
      | First Name           | Joe           |
      | Last Name            | Test          |
      | Email                | joe@test.com  |
      | Zip                  | 44444         |
      | Password             | abcd1234      |
      | People Aggregator ID | 12            |


  Scenario: Retrieve two contributions on an issue and a conversation
    Given a conversation:
      | ID          | 2                           |
      | Title       | This is a test conversation |
      | Image       | imageAttachment.png         |
      | Summary     | Test conversation           |
      | Zip Code    | 44111                       |
    And an issue:
      | ID          | 2                           |
      | Name        | This is a test issue        |
      | Image       | imageAttachment.png         |
      | Summary     | Test issue                  |
      | Zip Code    | 44111                       |
    And I have a comment on the conversation:
    """
    This is my example comment on the conversation
    """
    And I have a comment on the issue:
    """
    This is my example comment on the issue
    """
    When I ask for contributions with URL:
    """
    /api/12/contributions
    """
    Then I should receive a response:
    """
    [
      {
        "parent_title": "This is a test conversation",
        "parent_image": "http://s3.amazonaws.com/cc-dev/images/thumb/imageAttachment.png",
        "parent_image_width": 100,
        "parent_image_height": 100,
        "comment": "This is my example comment on the conversation",
        "participant_count": 2,
        "contribution_count": 1,
        "parent_url": "http://www.example.com/conversations/2"
        },
        {
          "parent_title":       "This is a test issue",
          "parent_image":       "http://s3.amazonaws.com/cc-dev/images/thumb/imageAttachment.png",
          "parent_image_width":        100,
          "parent_image_height":       100,
          "comment":                   "This is my example comment on the issue",
          "participant_count":  2,
          "contribution_count": 1,
          "parent_url":                "http://www.example.com/issues/2"
        }
    ]
    """


