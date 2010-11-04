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
      [{
        "parent_title": "Understanding The Latest Health Care Changes",
        "parent_type": "conversation",
        "parent_url": "http://www.example.com/conversations/2",
        "created_at": "2010-10-10T04:00:00Z",
        "content": "This goes to the same problem that there would be in the adult market. This is why there is this individual mandate for adults. This is why the pre-existing conditions for adults ban doesn't take effect until that mandate kicks in.",
        "attachment_url": "",
        "embed_code": "",
        "type": "comment",
        "link_text": "",
        "link_url": ""
      }]
      """

  @backlog
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

  @backlog
  Scenario: Retrieve a contribution with a suggestion
    Given I have contributed a suggestion:
      """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dignissim magna quis tortor dignissim non fringilla purus placerat. Maecenas eleifend arcu a metus viverra mattis. Maecenas sit amet nunc nisl. Quisque felis leo, pharetra at adipiscing sit amet, fringilla eget arcu. Nunc a magna mi, sit amet semper velit. Suspendisse ipsum sem, sollicitudin vel dapibus sit amet, pretium sed elit. Duis luctus, enim ac laoreet bibendum, arcu mi dapibus dolor, vel consectetur nulla libero at erat. Nulla facilisi. Donec elementum dignissim odio auctor vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vitae leo risus, quis tempor velit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc luctus tellus libero. Vivamus ut augue non sem volutpat ornare non eget augue. Maecenas dolor libero, consectetur ut dictum nec, imperdiet sed ante.
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
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dignissim magna quis tortor dignissim non fringilla purus placerat. Maecenas eleifend arcu a metus viverra mattis. Maecenas sit amet nunc nisl. Quisque felis leo, pharetra at adipiscing sit amet, fringilla eget arcu. Nunc a magna mi, sit amet semper velit. Suspendisse ipsum sem, sollicitudin vel dapibus sit amet, pretium sed elit. Duis luctus, enim ac laoreet bibendum, arcu mi dapibus dolor, vel consectetur nulla libero at erat. Nulla facilisi. Donec elementum dignissim odio auctor vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vitae leo risus, quis tempor velit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc luctus tellus libero. Vivamus ut augue non sem volutpat ornare non eget augue. Maecenas dolor libero, consectetur ut dictum nec, imperdiet sed ante."
            attachment_url: "",
            embed_code: "",
            type: "suggestion",
            link_text: "",
            link_url: ""
          }
        ]
      """

  @backlog
  Scenario: Retrieve a contribution with a question
    Given I have contributed a question:
      """
        I was wanting to know if you could clarify the points you made in your comment?  How will this effect...?
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
            content: "I was wanting to know if you could clarify the points you made in your comment?  How will this effect...?"
            attachment_url: "",
            embed_code: "",
            type: "question",
            link_text: "",
            link_url: ""
          }
        ]
      """

  @backlog
  Scenario: Retrieve a contribution with an attachment
    Given I have contributed an attachment "citation.pdf"
    And I have commented:
      """
        In this pdf, the author illustrates the results of changing ...
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
            content: "Checkout the article on ..."
            attachment_url: "",
            embed_code: "",
            type: "link",
            link_text: "Here's My Link",
            link_url: "http://www.cbsnews.com"
          }
        ]
      """
