Given /^that I am on the invitation page$/ do
  Factory.create(:conversation)
  visit new_invite_url
end

Given /^the invitee textarea is empty$/ do
  fill_in('invites_emails', :with => '')
end
