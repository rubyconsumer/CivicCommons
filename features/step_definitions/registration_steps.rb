Given /^the user signs up with:$/ do |table|
  visit '/people/register/new'

  values = table.rows_hash

  fill_in 'person[name]', with: values['Name']
  fill_in 'person[email]', with: values['Email']
  fill_in 'person[zip_code]', with: values['Zip']
  fill_in 'person[password]', with: values['Password']
  fill_in 'person[password_confirmation]', with: values['Password']

  click 'Register'

  @current_person = Person.where(email: values['Email']).first

  $encrypted_passwords[@current_person.email] = @current_person.encrypted_password
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




