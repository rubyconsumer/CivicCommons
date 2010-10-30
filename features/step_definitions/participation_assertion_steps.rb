Then /^the user should be logged in$/ do
  find("#login-status").text.should =~ /#{@current_person.name}/
end

