Given /^that I am on the invitation page$/ do
  @conversation = Factory.create(:conversation)
  visit new_invite_url(:source_type => :conversations, :source_id => @conversation.cached_slug)
end

Given /^the invitee textarea is empty$/ do
  fill_in('invites_emails', :with => '')
end
