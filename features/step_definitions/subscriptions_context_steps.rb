Given /^I am following the conversation$/ do
  @conversation.subscriptions.create(person: @current_person)
end

Given /^I am following the issue$/ do
  @issue.subscriptions.create(person: @current_person)
end

