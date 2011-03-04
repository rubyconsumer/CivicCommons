Then /be on the login page$/ do
  current_path.should == new_person_session_path
end

Then /be on the responsibilities page$/ do
  current_path.should == conversation_responsibilities_path
end

Then /see the responsibilities verbiage$/ do
  page.should have_content("your responsibilities")
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

Then /be on the invite participants page$/ do
  current_path.should == '/invites/new'
  page.should have_selector(:xpath, ".//input[@type='hidden'][@value=#{@conversation.id}]")
end

Then /see the success message$/ do
  page.should have_content('successfully created')
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
