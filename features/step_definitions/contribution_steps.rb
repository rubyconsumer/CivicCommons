Given /^I have a comment on the conversation:$/ do |comment|
  Factory.create(:contribution,
                 person: @current_person,
                 content: comment,
                 issue: nil,
                 conversation: @conversation)
end

Given /^I have a comment on the issue:$/ do |comment|
  Factory.create(:contribution,
                 person: @current_person,
                 content: comment,
                 conversation: nil,
                 issue: @issue)
end

