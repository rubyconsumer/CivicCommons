Feature:  Creating an Organization
  As an anonymous person
  I want to sign up for an account as an organization
  So that I can interact with the Civic Commons community


  @api
  Scenario: User signs up for account with email address, name, zip code, username, password, organization name

      Given the user signs up with:
        | Name         | Joe Test      |
        | Email        | joe@test.com  |
        | Zip          | 44444         |
        | Password     | abcd1234      |
        | Organization | Density Pop   |
      Then a user should be created with email "joe@test.com"
      And a PA Organization should be created with organization name "Density Pop"
      And a confirmation email is sent:
        | From    | admin@theciviccommons.com     |
        | To      | joe@test.com                  |
        | Subject | Confirmation instructions     |
      And a People Aggregator shadow account should be created

