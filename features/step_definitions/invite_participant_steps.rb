Given /^that I am on the invitation page$/ do
  @conversation = FactoryGirl.create(:conversation)
  visit new_invite_url(:source_type => :conversations, :source_id => @conversation.slug)
end

Given /^the invitee textarea is empty$/ do
  fill_in('invite_emails', :with => '')
end

When /click the 'Send Invitations' button$/ do
  click_on 'Send Invitations'
end

When /^I click the cancel link$/ do
  click_on 'Cancel'
end

When /^I click the 'Send' button$/ do
  click_on 'Send'
end

When /^I enter one or more comma\-delimited email addresses in the invitee textarea$/ do
  fill_in('invite_emails', :with => 'alpha@example.com, bravo@example.com, charlie@example.com')
end

Then /should be on the conversation page$/ do
  current_path.should == conversation_path(@conversation)
end

Then /^I will be on the invitation page$/ do
  current_path.should == new_invite_path
end

Then /^I should see a textarea for invitee email addresses$/ do
  page.should have_selector('textarea#invite_emails')
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
