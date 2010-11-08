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
    | type          | comment                                                                | attachment_url                                      | embed_code                                                                             | link_text                                                   | link_url                                   |
    | comment       | This goes to the same problem that there would be in the adult market. |                                                     |                                                                                        |                                                             |                                            |
    | video         | Check out this sweet goal.                                             |                                                     | <test_embed src='http://www.youtube.com/v/qq7nkbvn1Ic?fs=1&amp;hl=en_US'></test_embed> | YouTube - David Perron Goal vs Islanders - November 21 2009 | http://www.youtube.com/watch?v=qq7nkbvn1Ic |
    | suggestion    | Lorem ipsum dolor sit amet, consectetur adipiscing elit.               |                                                     |                                                                                        |                                                             |                                            |
    | question      | I was wanting to know if you could clariyf the points in your comment? |                                                     |                                                                                        |                                                             |                                            |
    | attached_file | In this pdf, you can see...                                            | http://s3.amazonaws.com/cc-dev/attachments/original/test_pdf.pdf   |                                                                                        |                                                             |                                            |
    | image         | This image illustrates...                                              | http://s3.amazonaws.com/cc-dev/attachments/original/test_image.jpg |                                                                                        |                                                             |                                            |
    | link          | This site is amazing                                                   |                                                     |                                                                                        | Yahoo!                                                      | http://www.yahoo.com                       |


  @backlog
  Scenario: Requesting for a PA user that does not exist
    When I ask for contributions for the person with People Aggregator ID 1000321
    Then I should receive a "404 Not Found" response
