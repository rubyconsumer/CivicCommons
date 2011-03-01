Then /should be on the conversation page$/ do
  current_path.should == "/conversations"
end

Then /will see an 'Invite Participants' button$/ do
  find_by_id("invite-participant").text.should =~ /Invite Participants/
end

Then /will not see an 'Invite Participants' button$/ do
    page.has_no_selector?("invite-participant")
end

Then /^I will be on the invitation page$/ do
  find(".main-content").text.should =~ /Who do you want to invite to join this conversation?/
end

Then /^I should see a textarea for invitee email addresses$/ do
  page.should have_selector('textarea#invites_emails')
end

Then /^I should see a 'Send' button$/ do
  find('input.submit').value.should =~ /Send/
end

Then /^I should see a 'Cancel' link$/ do
  find('input.button').value.should =~ /Cancel/
end

Then /^no email invitations should be sent$/ do
  mailing = ActionMailer::Base.deliveries.first
  mailing.should == nil
end

Then /^I should see an error message$/ do
  find('.flash-notice').text.should =~ /There was a problem with the entered emails./
end

Then /^I should see a success message$/ do
  find('.flash-notice').text.should =~ /Thank you! You're helping to make Northeast Ohio stronger!/
end
