When /^I try to create the user without a login:$/ do |table|
  rows = table.rows_hash

  @code_to_run = lambda {
    PeopleAggregator::Person.create(firstName: rows['First'],
                                    lastName:  rows['Last'],
                                    password:  rows['Password'],
                                    email:     rows['Email'])
  }
end

When /^I try to create a duplicate user with login "([^"]*)"$/ do |login|
  @code_to_run = lambda {
    PeopleAggregator::Person.create(firstName: "first",
                                    lastName:  "last",
                                    password:  "abcd1234",
                                    email:     login,
                                    login:     login)
    PeopleAggregator::Person.create(firstName: "first",
                                    lastName:  "last",
                                    password:  "abcd1234",
                                    email:     login,
                                    login:     login)
  }
end

Then /^I should receive an? "([^"]*)" with the message:$/ do |error, string|

  @code_to_run.should raise_error(error.constantize, string)
end

