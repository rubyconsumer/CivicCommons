Feature:
  As a developer
  I want to understand responses from the API
  so that I can quickly debug problems

  Scenario: Missing a required key
    When I try to create the user without a login:
      | First     | Joe           |
      | Last      | Test          |
      | Email     | joe@test.com  |
      | Zip       | 44444         |
      | Password  | abcd1234      |
    Then I should recieve an "ArgumentError" with the message:
      """
      The key "login" is required.
      """

