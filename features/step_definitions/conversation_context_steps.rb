Given /^a conversation:$/ do |table|

  conversation = table.rows_hash

  admin_person = Factory.create(:admin_person,
                                first_name: 'Test',
                                last_name: 'Admin')

  attachment =  if conversation['Image']
                  File.open(File.join(attachments_path, conversation['Image']))
                end

  @conversation =
    Factory.create(:conversation,
                   id:    conversation['ID'],
                   title: conversation['Title'],
                   image: attachment,
                   summary: conversation['Summary'],
                   zip_code: conversation['Zip Code'])

  Factory.create(:top_level_contribution,
                 conversation: @conversation)

end


Given /^I have [a\s]?(\d*|\w*)\s?comments? on the conversation$/ do |number|
  number = words_to_num(number) unless number =~ /\d+/

  number.times do
    Factory.create(:comment_with_unique_content,
                   created_at: Date.parse("2010/10/10"),
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


Given /^I am following the conversation:$/ do |table|
  Given("a conversation:", table)
  @conversation.subscribe(@current_person)
  sleep(2)
end

