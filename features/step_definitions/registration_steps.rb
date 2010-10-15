Given /^the user signs up with:$/ do |table|
  visit '/people/register/new'

  values = table.rows_hash

  fill_in 'person[name]', with: values['Name']
  fill_in 'person[email]', with: values['Email']
  fill_in 'person[zip_code]', with: values['Zip']
  fill_in 'person[password]', with: values['Password']
  fill_in 'person[password_confirmation]', with: values['Password']

  attach_file("person[avatar]", File.join(attachments_path, 'imageAttachment.png'))

  if values['Organization']
    check 'organization'
    fill_in 'organization_name', with: values['Organization']
  end

  click 'Register'

  @current_person = Person.where(email: values['Email']).first

end


Then /^a PA Organization should be created with organization name "([^"]*)"$/ do |name|
  PeopleAggregator::Organization.
    find_by_admin_email(@current_person.email).name.should == name
end



Then /^a user should be created with email "([^"]*)"$/ do |email|
  Person.where(email: email).count.should == 1
end


Then /^a confirmation email is sent:$/ do |table|
  values = table.rows_hash

  mailing = ActionMailer::Base.deliveries.first

  mailing.from.should == [values['From']]
  mailing.to.should == [values['To']]
  mailing.subject.should == values['Subject']
end


When /^the user confirms his account$/ do

  confirmation_token = @current_person.confirmation_token

  visit '/people/verification?confirmation_token=%s' % confirmation_token

end


Then /^the user should be confirmed$/ do
  @current_person = Person.where(email: @current_person.email).first
  @current_person.confirmed_at.to_date.should == Time.now.utc.to_date
end


Then /^the user should be logged in$/ do
  find("#login-status").text.should =~ /#{@current_person.name}/
end


Then /^a People Aggregator shadow account should be created$/ do
  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)

  peep_agg_person.should_not be_nil
  peep_agg_person.login.should == @current_person.email
end


Then /^a People Aggregator shadow account should not be created$/ do
  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)

  peep_agg_person.should be_nil
end


Given /^a registered user:$/ do |table|
  user = table.rows_hash

  @current_person =
    Factory.create(:registered_user,
                   first_name:           user['First Name'],
                   last_name:            user['Last Name'],
                   email:                user['Email'],
                   avatar:                File.open(File.join(attachments_path, 'imageAttachment.png')),
                   zip_code:             user['Zip'],
                   people_aggregator_id: user['People Aggregator ID'],
                   password:             user['Password'])
end

When /^I delete the user$/ do
  @deleted_person_email = @current_person.email
  @current_person.destroy
end

Then /^the user's People Aggregator shadow account should no longer exist$/ do
  PeopleAggregator::Person.find_by_email(@deleted_person_email).should be_nil
end


