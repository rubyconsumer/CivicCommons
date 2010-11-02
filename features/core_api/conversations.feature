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
