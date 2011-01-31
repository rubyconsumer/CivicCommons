Then /^a user should be created with email "([^"]*)"$/ do |email|
  Person.where(email: email).count.should == 1
end


Then /^a confirmation email is sent:$/ do |table|
  values = table.rows_hash

  mailing = ActionMailer::Base.deliveries.first

  mailing.from.should == [Civiccommons::Config.devise_email]
  mailing.to.should == [values['To']]
  mailing.subject.should == values['Subject']
end



Then /^the user should be confirmed$/ do
  @current_person = Person.where(email: @current_person.email).first
  @current_person.confirmed_at.to_date.should == Time.now.utc.to_date
end

