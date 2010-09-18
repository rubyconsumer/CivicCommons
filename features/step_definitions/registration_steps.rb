Given /^the user signs up with:$/ do |table|
  visit '/people/register/new'

  values = table.rows_hash

  fill_in 'person[name]', with: values['Name']
  fill_in 'person[email]', with: values['Email']
  fill_in 'person[zip_code]', with: values['Zip']
  fill_in 'person[password]', with: values['Password']
  fill_in 'person[password_confirmation]', with: values['Password']

  click 'Register'

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


When /^"([^"]*)" confirms his account$/ do |email|

  confirmation_token = Person.where(:email => email).first.confirmation_token

  visit '/people/verification?confirmation_token=%s' % confirmation_token

end


Then /^"([^"]*)" should be confirmed$/ do |email|
  Person.where(:email => email).first.confirmed_at.to_date.should == Date.today
end


Then /^"([^"]*)" should be logged in$/ do |email|
  find("#login-status").text.should =~ /#{email}/
end




