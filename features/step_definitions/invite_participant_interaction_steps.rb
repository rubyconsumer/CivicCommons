When /click the 'Invite Participants' button$/ do
  click_on 'Invite Participants'
end

When /^I click the cancel link$/ do
  click_on 'Cancel'
end

When /^I click the 'Send' button$/ do
  click_on 'Send'
end

When /^I enter one or more comma\-delimited email addresses in the invitee textarea$/ do
  fill_in('invites_emails', :with => 'alpha@example.com, bravo@example.com, charlie@example.com')
end
