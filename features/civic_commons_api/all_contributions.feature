Feature: Send PeopleAggregator All contributions Made by a specific user
  As a PeopleAggregator Developer
  I want to be able to retrieve all the contributions a user has submitted
  So that I can display the details on the user's profile page

Background:
  Given a registered user:
      | First Name           | Joe           |
      | Last Name            | Test          |
      | Email                | joe@test.com  |
      | Zip                  | 44444         |
      | Password             | abcd1234      |
      | People Aggregator ID | 12            |

  Scenario: Retrieve a contribution containing an embedded video
    Given I have contributed a video
    When I ask for contributions with URL:
    """
    api/people/12/contributions
    """
    Then I should receive a response:
    """
    [
      {
        parent_title: "The Title of the Conversation",
        parent_type: "conversation",
        parent_url: "http://.../conversations/8",
        created_at: "10/10/2010",
        content: "Blah",
        attachment_url: '',
        embed_code: "<object>...</object>",
        type: "video",
        link_text: '',
        link_url: ''
      }
    ]

    """

  Scenario: Retrieve a contribution containing a comment
    Given I have contributed a comment
    When I ask for contributions with URL:
    """
    api/people/12/contributions
    """
    Then I should receive a response:
    """
    [
      {
        parent_title: "The Title of the Conversation",
        parent_type: "conversation",
        parent_url: "http://.../conversations/8",
        created_at: "10/10/2010",
        content: "Blah",
        attachment_url: '',
        embed_code: "",
        type: "comment",
        link_text: '',
        link_url: ''
      }
    ]
    """




  Scenario: Retrieve a contribution containing a suggestion

  Scenario: Retrieve a contribution containing a question

  Scenario: Retrieve a contribution containing an attachment

  Scenario: Retrieve a contribution containing an image

  Scenario: Retrieve a contribution containing a link

  Scenario: Retrieve multiple contributions
