Given /^a member who is missing required information$/ do
  @member = Person.new({:email => 'member_missing_info@website.com', :first_name=>'zee', :last_name => 'Your', :name=>'Zee', :daily_digest => true })
end

Given /^a member$/ do
  @member = Factory.build(:normal_person) 
end

When /^they unsubscribe from the daily digest$/ do
  @member.unsubscribe_from_daily_digest
end

Then /^they should be unsubscribed from the daily digest$/ do
  @member = Person.find_by_email(@member.email)
  @member.should_not be_subscribed_to_daily_digest
end
