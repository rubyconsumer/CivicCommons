When /^I ask for \w+ with URL:$/ do |url|
  @url = url
end


When /^I ask for contributions for the person with ID (\d+)$/ do |person_id|
  @url = "/api/#{person_id}/contributions"
end


When /^I ask for subscriptions for the person with ID (\d+)$/ do |person_id|
  @url = "/api/#{person_id}/subscriptions"
end

When /^I ask for (issues|conversations) the person with ID (\d+) is following$/ do |type, person_id|
  @url = "/api/#{person_id}/subscriptions?type=#{type.singularize}"
end

When /^I ask for one page of contributions for the person with ID (\d+)$/ do |person_id|
  @url = "/api/#{person_id}/contributions?page=1&per_page=#{@per_page}"
end

