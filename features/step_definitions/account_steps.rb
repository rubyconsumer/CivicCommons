Given /^the user signs up with:$/ do |table|

  visit '/people/register/new'

  values = table.rows_hash

  fill_in 'person[name]', with: values['Name']
  fill_in 'person[email]', with: values['Email']
  fill_in 'person[zip_code]', with: values['Zip']
  fill_in 'person[password]', with: values['Password']
  fill_in 'person[password_confirmation]', with: values['Password']
  attach_file("person[avatar]", File.join(attachments_path, 'imageAttachment.png'))

  click_button 'Continue'

  @current_person = Person.where(email: values['Email']).first
end

When /^the user confirms his account$/ do

  confirmation_token = @current_person.confirmation_token

  visit '/people/verification?confirmation_token=%s' % confirmation_token

end

Then /^a user should be created with email "([^"]*)"$/ do |email|
  Person.where(email: email).count.should == 1
end


Then /^a confirmation email is sent:$/ do |table|
  values = table.rows_hash

  mailing = ActionMailer::Base.deliveries.first

  mailing[:from].to_s.should == Civiccommons::Config.devise['email']
  mailing.to.should == [values['To']]
  mailing.subject.should == values['Subject']
end



Then /^the user should be confirmed$/ do
  @current_person = Person.where(email: @current_person.email).first
  @current_person.confirmed_at.to_date.should == Time.now.utc.to_date
end

