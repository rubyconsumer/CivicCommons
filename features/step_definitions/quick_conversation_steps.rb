Given /^I am on the admin home page$/ do
  visit admin_root_path
end

When /^I click "([^"]*)"$/ do |navigation_link|
  click_link "Add Simple Conversation"
end

Then /^I should be on the new simple conversation page$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am on the new simple conversation page$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I fill in the form with:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When /^I add a file as the Top Level Contribution$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be on the admin conversation page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a message "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

