Given /^the user signs up with:$/ do |table|

  visit '/people/register/new'

  values = table.rows_hash

  fill_in 'person[name]', with: values['Name']
  fill_in 'person[email]', with: values['Email']
  fill_in 'person[zip_code]', with: values['Zip']
  fill_in 'person[password]', with: values['Password']
  fill_in 'person[password_confirmation]', with: values['Password']
  fill_in 'person_invite_attributes_invitation_token', with: "ABC1234"
  attach_file("person[avatar]", File.join(attachments_path, 'imageAttachment.png'))

  if values['Organization']
    check 'organization'
    fill_in 'organization_name', with: values['Organization']
  end

  click 'Continue'

  @current_person = Person.where(email: values['Email']).first
end
