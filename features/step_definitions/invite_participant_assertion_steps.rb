Then /should be on the conversation page$/ do
  current_path.should == conversation_path(@conversation)
end

Then /^I will be on the invitation page$/ do
  current_path.should == new_invite_path
end

Then /^I should see a textarea for invitee email addresses$/ do
  page.should have_selector('textarea#invites_emails')
end

Then /^no email invitations should be sent$/ do
  mailing = ActionMailer::Base.deliveries.first
  mailing.should == nil
end

Then /^I should see an error message$/ do
  page.should have_content('There was a problem')
end

Then /^I should see a success message$/ do
  page.should have_content('Thank you!')
end
