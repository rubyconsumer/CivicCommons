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
    And a conversation:
      | ID          | 2                           |
      | Title       | Understanding The Latest Health Care Changes |


  @wip
  Scenario Outline: Retrieve a contribution
    Given I have contributed a <type>:
      """
      <comment>
      """
    When I ask for contributions for the person with People Aggregator ID 12
    Then I should receive the response:
    """
    [{
      "parent_title": "Understanding The Latest Health Care Changes",
      "parent_type": "conversation",
      "parent_url": "http://www.example.com/conversations/2",
      "created_at": "2010-10-10T04:00:00Z",
      "content": "<comment>",
      "attachment_url": "<attachment_url>",
      "embed_code": "<embed_code>",
      "type": "<type>",
      "link_text": "<link_text>",
      "link_url": "<link_url>"
    }]
    """

  Examples:
    | type       | comment                                                                | attachment_url | embed_code                                                                             | link_text | link_url                                   |
    | comment    | This goes to the same problem that there would be in the adult market. |                |                                                                                        |           |                                            |
    | video      | Check out this sweet goal.                                             |                | <test_embed src='http://www.youtube.com/v/qq7nkbvn1Ic?fs=1&amp;hl=en_US'></test_embed> |           | http://www.youtube.com/watch?v=qq7nkbvn1Ic |
    | suggestion | Lorem ipsum dolor sit amet, consectetur adipiscing elit.               |                |                                                                                        |           |                                            |
    | question   | I was wanting to know if you could clariyf the points in your comment? |                |                                                                                        |           |                                            |



  @backlog
  Scenario: Retrieve a contribution with an attachment
    Given I have contributed an attachment "citation.pdf"
    And I have commented:
      """
        In this pdf, the author illustrates the results of changing ...
      """
    When I ask for contributions for the person with People Aggregator ID 12
    Then I should receive the response:
      """
        [
          {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "In this pdf, the author illustrates the results of changing ..."
            attachment_url: "http://s3.amazon.com/civiccommons/citation.pdf",
            embed_code: "",
            type: "attchment",
            link_text: "",
            link_url: ""
          }
        ]
      """

  @backlog
  Scenario: Retrieve a contribution with an image
    Given I have contributed an image "picture.png"
    And I have commented:
      """
        Look at this.
      """
    When I ask for contributions for the person with People Aggregator ID 12
    Then I should receive the response:
      """
        [
          {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "Look at this."
            attachment_url: "http://s3.amazon.com/civiccommons/picture.jpg",
            embed_code: "",
            type: "image",
            link_text: "",
            link_url: ""
          }
        ]
      """

  @backlog
  Scenario: Retrieve a contribution with a link
    Given I have contributed a link "http://www.cbsnews.com" with the text "Here's My Link"
    And I have commented:
      """
        Checkout the article on ...
      """
    When I ask for contributions for the person with People Aggregator ID 12
    Then I should receive the response:
      """
        [
          {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "Checkout the article on ..."
            attachment_url: "",
            embed_code: "",
            type: "link",
            link_text: "Here's My Link",
            link_url: "http://www.cbsnews.com"
          }
        ]
      """

  @backlog
  Scenario: Requesting for a PA user that does not exist
    When I ask for contributions for the person with People Aggregator ID 1000321
    Then I should receive a "404 Not Found" response
