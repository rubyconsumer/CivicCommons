@wip
Feature:
  As a registered user
  I want to sign into the site
  So that I can interact with the Civic Commons community


  Background:
    Given a registered user:
      | Name      | Joe Test      |
      | Email     | joe@test.com  |
      | Zip       | 44444         |
      | Password  | abcd1234      |


  Scenario: Log in to the site
    Given I am logged in as joe@test.com
    Then I should be logged into PeopleAggregator as well
