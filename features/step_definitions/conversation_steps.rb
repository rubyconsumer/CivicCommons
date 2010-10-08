Given /^a conversation:$/ do |table|

  conversation = table.rows_hash

  admin_person = Factory.create(:admin_person,
                                first_name: 'Test',
                                last_name: 'Admin')

  attachment = File.join(attachments_path, conversation['Image'])

  @conversation =
    Factory.create(:conversation,
                   title: conversation['Title'],
                   image: File.open(attachment),
                   summary: conversation['Summary'],
                   zip_code: conversation['Zip Code'])

  Factory.create(:top_level_contribution,
                 conversation: @conversation)

end


Given /^I have a comment on the conversation$/ do
  Factory.create(:comment,
                 person: @current_person,
                 conversation: @conversation)
end

