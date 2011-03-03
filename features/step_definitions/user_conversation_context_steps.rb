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
  #check 'conversation[issue_ids][]'
  attach_file('conversation[image]', File.join(attachments_path, 'imageAttachment.png'))

  fill_in 'conversation[contributions_attributes][0][content]', with: @values['Comment']
end

Given /am on the invite participants page$/ do
  @conversation = Factory.create(:conversation)
  Given 'a clear email queue'
  visit new_invite_url(:source_type => :conversations, :source_id => @conversation.id)
end
