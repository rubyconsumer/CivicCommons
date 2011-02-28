When /select the "([^"]*)" link$/ do |name|
  click_link name
end

When /press the "([^"]*)" button$/ do |name|
  click_link_or_button(name)
end

When /visit the conversation creation page directly$/ do
  visit new_conversation_path
end
