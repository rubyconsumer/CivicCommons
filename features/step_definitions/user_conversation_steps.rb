Given /am on the home page$/ do
  visit path_to('the homepage')
end

Given /am on the responsibilities page$/ do
  visit conversation_responsibilities_path
end

Given /am on the conversation creation page$/ do
  Factory.create(:issue)
  visit new_conversation_path(:accept => true)
  @issues = [Issue.first]
end

Given /have entered valid conversation data:$/ do |table|
  @values = table.rows_hash

  fill_in 'conversation[title]', with: @values['Title']
  fill_in 'conversation[summary]', with: @values['Summary']
  fill_in 'conversation[zip_code]', with: @values['Zip Code']
  # BUG: This doesn't work right with Capybara
  #      instead of submitting ["1"], it submits ["[\"1\"]"]
  #      see https://github.com/jnicklas/capybara/issues/#issue/283
  #
  check 'conversation[issue_ids][]'
  attach_file('conversation[image]', File.join(attachments_path, 'imageAttachment.png'))

  fill_in 'conversation[contributions_attributes][0][content]', with: @values['Comment']
end

Given /am on the Send Invitations page after creating a conversation$/ do
  @conversation = Factory.create(:conversation)
  Given 'a clear email queue'
  visit new_invite_url(:source_type => :conversations, :source_id => @conversation.id, :conversation_created => true)
end

When /select the "([^"]*)" link$/ do |name|
  click_link name
end

When /(?:press|click) the "([^"]*)" button$/ do |name|
  click_link_or_button(name)
end

When /visit the conversation creation page directly$/ do
  visit new_conversation_path
end

Then /be on the login page$/ do
  current_path.should == new_person_session_path
end

Then /be on the responsibilities page$/ do
  current_path.should == conversation_responsibilities_path
end

Then /see the responsibilities verbiage$/ do
  page.should have_content("responsibilities")
end

Then /be redirected to the responsibilities page$/ do
  current_path.should == conversation_responsibilities_path
end

Then /be on the home page$/ do
  current_path.should == path_to('the homepage')
end

Then /^no conversation will be created$/ do
  Conversation.count.should == 0
end

Then /be on the conversation creation page$/ do
  current_path.should == new_conversation_path
end

Then /see an? Issues selection field$/ do
  page.should have_field('conversation[issue_ids][]')
end

Then /see an? image upload field$/ do
  page.should have_field('conversation[image]')
end

Then /^the conversation should be created$/ do
  @conversation = Conversation.where(title: @values['Title']).first
  @conversation.should_not be_nil
  #@conversation.issues.should == @issues
end

Then /be on the Send Invitations page$/ do
  current_path.should == '/invites/new'
  page.should have_selector(:xpath, ".//input[@type='hidden'][@value=#{@conversation.id}]")
end

Then /see the success message$/ do
  page.should have_content('created')
end

Then /see the conversation box and image$/ do
  page.should have_content(@conversation.title)
  page.should have_xpath("//img[@src=\"#{@conversation.image.url(:panel)}\"]")
end

Then /be on the conversation page for my conversation$/ do
  current_path.should == conversation_path(@conversation)
end

Then /^no invitations should be sent$/ do
  Then 'they should receive no emails'
end
