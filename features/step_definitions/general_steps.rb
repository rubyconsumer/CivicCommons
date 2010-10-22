require 'cucumber/rspec/doubles'

Given /^I am logged in as an admin$/ do
  @current_user = mock(Person)
  @current_user.stub!(:admin?).and_return(true)
end

