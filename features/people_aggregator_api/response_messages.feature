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
    Then I should receive an "ArgumentError" with the message:
      """
      The key "login" is required.
      """

  @api
  Scenario: Creating a user that already exists
    When I try to create a duplicate user with login "joe@duplicate.com"
    Then I should receive a "StandardError" with the message:
      """
      The user with login "joe@duplicate.com" already exists.
      """
