Then /be on the responsibilities page$/ do
  current_path.should == conversation_responsibilities_path
end

Then /see the responsibilities verbiage$/ do
  page.should have_content("your responsibilities")
end

Then /see an? "([^"]*)" link/ do |name|
  page.should have_link(name)
end

Then /see an? "([^"]*)" button$/ do |name|
  page.should have_selector('input[type=submit],button,a.button', :text => name)
end

Then /see an? "([^"]*)" submit button$/ do |name|
  page.should have_selector("input[type=submit][value='#{name}']")
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

Then /see an? "([^"]*)" text (box|area)$/ do |name, el|
  page.should have_field(name)
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

Then /be on the conversation creation success page$/ do
  current_path.should == conversation_path(@conversation)
end

Then /see the success message$/ do
  page.should have_content("Conversation created successfully")
end

Then /see the conversation box and image$/ do
  pending # express the regexp above with the code you wish you had
end

Then /be on the conversation page for my conversation$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^no invitations should be sent$/ do
  pending # express the regexp above with the code you wish you had
end

Then /be on the invite participants page$/ do
  pending # express the regexp above with the code you wish you had
end
