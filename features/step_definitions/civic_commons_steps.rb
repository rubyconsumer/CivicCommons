When /^I ask for conversations with URL:$/ do |url|
  @url = url
end


Then /^I should receive a response:$/ do |expected|
  visit(@url)
  actual = page.body
  JSON.parse(actual).should == JSON.parse(expected)
end

