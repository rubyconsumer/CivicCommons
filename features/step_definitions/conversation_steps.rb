Given /^a conversation:$/ do |table|

  conversation = table.rows_hash

  admin_person = Factory.create(:admin_person,
                                first_name: 'Test',
                                last_name: 'Admin')

  attachments_path = File.expand_path(
                        File.dirname(__FILE__) + '/../support/attachments')

  attachment = File.join(attachments_path, conversation['Image'])

  Factory.create(:conversation,
                 title: conversation['Title'],
                 image: attachment,
                 summary: conversation['Summary'],
                 moderator: admin_person,
                 zip_code: conversation['Zip Code'])

end


Given /^I have a comment on the conversation$/ do
  pending # express the regexp above with the code you wish you had
end

