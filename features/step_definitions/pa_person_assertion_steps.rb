Then /^a People Aggregator shadow account should be created$/ do
  stub_request(:get, "#{Civiccommons::PeopleAggregator.URL}/api/json.php/peopleaggregator/getUserProfile?login=joe@test.com").
    to_return(:body => File.open("#{Rails.root}/test/fixtures/example_pa_user_profile.html"),
      :headers => {'content-type' => 'application/javascript; charset=UTF-8'}, :status => 200)

  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)
  peep_agg_person.should_not be_nil
  peep_agg_person.login.should == @current_person.email
end


Then /^a People Aggregator shadow account should not be created$/ do
  stub_request(:get, "#{Civiccommons::PeopleAggregator.URL}/api/json.php/peopleaggregator/getUserProfile?login=joe@test.com").
    to_return(:status => 404)

  peep_agg_person = PeopleAggregator::Person.find_by_email(@current_person.email)
  peep_agg_person.should be_nil
end


Then /^the user's People Aggregator shadow account should no longer exist$/ do
  stub_request(:get, "#{Civiccommons::PeopleAggregator.URL}/api/json.php/peopleaggregator/getUserProfile?login=joe@test.com").
    to_return(:status => 404)

  PeopleAggregator::Person.find_by_email(@deleted_person_email).should be_nil
end

