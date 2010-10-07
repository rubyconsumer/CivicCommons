Feature:
  As a People Aggregator developer
  I want to be able to retrieve issues a user is participating in
  So that I can display the details on the user's profile page

  Background:
    Given a registered user:
      | First Name | Joe           |
      | Last Name  | Test          |
      | Email      | joe@test.com  |
      | Zip        | 44444         |
      | Password   | abcd1234      |


  Scenario: Retrieve one issue in which the user is participating
    Given an issue:
      | ID          | 2                           |
      | Name        | This is a test issue        |
      | Summary     | Test issue                  |
      | Zip Code    | 44111                       |
    And I have a contribution on the issue
    When I ask for issues with URL:
    """
    /api/joe@test.com/issues
    """
    Then I should receive a response:
    """
    [
      {
        "name":               "This is a test issue",
        "summary":            "Test issue",
        "participant_count":  1,
        "contribution_count": 1,
        "url":                "http://www.example.com/issues/2"
      }
    ]
    """

