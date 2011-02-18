Given /^a registered user:$/ do |table|
  user = table.rows_hash

  @current_person =
    Factory.create(:registered_user,
                   first_name:           user['First Name'],
                   last_name:            user['Last Name'],
                   email:                user['Email'],
                   avatar:                File.open(File.join(attachments_path, 'imageAttachment.png')),
                   zip_code:             user['Zip'],
                   password:             user['Password'],
                   id:                   user['ID'])

end


