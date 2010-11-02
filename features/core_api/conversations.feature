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
  Scenario: Retrieve a contribution with a comment
    Given I have contributed a comment:
      """
        This goes to the same problem that there would be in the adult market. This is why there is this individual mandate for adults. This is why the pre-existing conditions for adults ban doesn't take effect until that mandate kicks in.
      """
    When I ask for contributions with URL:
      """
      /api/people-aggregator/person/12/contributions
      """
    Then I should receive the response:
      """
      [
        {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "This goes to the same problem that there would be in the adult market. This is why there is this individual mandate for adults. This is why the pre-existing conditions for adults ban doesn't take effect until that mandate kicks in.",
            attachment_url: "",
            embed_code: "",
            type: "comment",
            link_text: "",
            link_url: ""
        }

      ]
      """

  Scenario: Retrieve a contribution with an embeded video
    Given I have contributed a video url:
      """
        http://www.youtube.com/watch?v=qq7nkbvn1Ic
      """
    And I included the comment:
      """
        Check out this sweet goal.
      """
    When I ask for contributions with URL:
      """
        /api/people-aggregator/person/12/contributions
      """
    Then I should receive the response:
      """
        [
          {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "Check out this sweet goal."
            attachment_url: "",
            embed_code: "<object width='300' height='180'><param name='wmode' value='opaque'></param><param name='movie' value='http://www.youtube.com/v/qq7nkbvn1Ic?fs=1&amp;hl=en_US'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed wmode='opaque' src='http://www.youtube.com/v/qq7nkbvn1Ic?fs=1&amp;hl=en_US' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='300' height='180'></embed></object>",
            type: "video",
            link_text: "",
            link_url: "http://www.youtube.com/watch?v=qq7nkbvn1Ic"
          }
        ]
      """
  
  Scenario: Retrieve a contribution with an embeded video
    Given I have contributed a suggestion:
      """
        I think the best way to handle this is to...
      """
    When I ask for contributions with URL:
      """
        /api/people-aggregator/person/12/contributions
      """
    Then I should receive the response:
      """
        [
          {
            parent_title: "Understanding The Latest Health Care Changes",
            parent_type: "conversation",
            parent_url: "http://.../conversations/2",
            created_at: "10/10/2010",
            content: "I think the best way to handle this is to..."
            attachment_url: "",
            embed_code: "",
            type: "suggestion",
            link_text: "",
            link_url: ""
          }
        ]
      """

