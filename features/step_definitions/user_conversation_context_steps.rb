Given /have a user account$/ do
  Factory.create(:registered_user)
end

Given /am logged in$/ do
  @current_person = Person.first
end

Given /am on the home page$/ do
  visit '/'
end

Given /am on the responsibilities page$/ do
  visit '/conversations/responsibilities'
end

Given /am on the conversation creation page$/ do
  visit '/conversations/new'
end

Given /have entered valid conversation data$/ do
  pending # express the regexp above with the code you wish you had
end

Given /am on the conversation creation success page$/ do
  pending # express the regexp above with the code you wish you had
end
