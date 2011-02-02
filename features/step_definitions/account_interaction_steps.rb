When /^the user confirms his account$/ do

  confirmation_token = @current_person.confirmation_token

  visit '/people/verification?confirmation_token=%s' % confirmation_token

end

#TODO: Change to "When I delete my account"
When /^I delete the user$/ do
  stub_request(:post, "#{Civiccommons::PeopleAggregator.URL}/api/json.php/peopleaggregator/deleteUser").
    with(:body => "adminPassword=admin&login=joe%40test.com").
    to_return(:body => File.open("#{Rails.root}/test/fixtures/example_pa_user_deleted.html"),
      :headers => {'content-type' => 'application/javascript; charset=UTF-8'}, :status => 200)

  @deleted_person_email = @current_person.email
  @current_person.destroy
end

