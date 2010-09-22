When /^I try to create the user without a login:$/ do |table|
  rows = table.rows_hash

  @code_to_run = lambda {
    PeopleAggregator::Person.create(firstName: rows['First'],
                                    lastName:  rows['Last'],
                                    password:  rows['Password'],
                                    email:     rows['Email'])
  }
end


Then /^I should recieve an "([^"]*)" with the message:$/ do |arg1, string|

  @code_to_run.should raise_error(ArgumentError, string)
end

