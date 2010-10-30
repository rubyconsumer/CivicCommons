Then /^a People Aggregator shadow account should be created$/ do
  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)

  peep_agg_person.should_not be_nil
  peep_agg_person.login.should == @current_person.email
end


Then /^a People Aggregator shadow account should not be created$/ do
  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)

  peep_agg_person.should be_nil
end


Then /^the user's People Aggregator shadow account should no longer exist$/ do
  PeopleAggregator::Person.find_by_email(@deleted_person_email).should be_nil
end

