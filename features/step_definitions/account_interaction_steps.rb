When /^the user confirms his account$/ do

  confirmation_token = @current_person.confirmation_token

  visit '/people/verification?confirmation_token=%s' % confirmation_token

end

#TODO: Change to "When I delete my account"
When /^I delete the user$/ do
  @deleted_person_email = @current_person.email
  @current_person.destroy
end

