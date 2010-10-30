Given /^a conversation:$/ do |table|

  conversation = table.rows_hash

  admin_person = Factory.create(:admin_person,
                                first_name: 'Test',
                                last_name: 'Admin')

  attachment = File.join(attachments_path, conversation['Image'])

  @conversation =
    Factory.create(:conversation,
                   id:    conversation['ID'],
                   title: conversation['Title'],
                   image: File.open(attachment),
                   summary: conversation['Summary'],
                   zip_code: conversation['Zip Code'])

  Factory.create(:top_level_contribution,
                 conversation: @conversation)

end


Given /^I have [a\s]?(\d*|\w*)\s?comments? on the conversation$/ do |number|
  number = words_to_num(number) unless number =~ /\d+/

  number.times do
    Factory.create(:comment,
                   person: @current_person,
                   conversation: @conversation)
  end

end

Given /^I have comment on the conversation:$/ do |comment|
  Factory.create(:contribution,
                 person: @current_person,
                 content: comment,
                 issue: nil,
                 conversation: @conversation)
end

