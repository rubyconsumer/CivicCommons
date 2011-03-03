Then /^I should receive an? "([^"]*)" with the message:$/ do |error, string|
  @code_to_run.should raise_error(error.constantize, string)
end

Given /^I am on the (\w+) index page/ do |resource|
  visit send("#{resource.downcase.pluralize}_url")
end
