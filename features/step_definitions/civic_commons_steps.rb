When /^I ask for \w+ with URL:$/ do |url|
  @url = url
end


Then /^I should receive a response:$/ do |expected|
  visit(@url)
  actual = page.body

  actual = "{}" if actual.strip.blank?

  JSON.parse(actual).should == JSON.parse(expected)
end

