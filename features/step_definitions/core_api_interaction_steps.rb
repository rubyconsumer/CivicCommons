When /^I ask for \w+ with URL:$/ do |url|
  @url = url
end


When /^I ask for contributions for the person with People Aggregator ID (\d+)$/ do |person_id|
  @url = "/api/people-aggregator/person/#{person_id}/contributions"
end


When /^I ask for subscriptions for the person with People Aggregator ID (\d+)$/ do |person_id|
  @url = "/api/people-aggregator/person/#{person_id}/subscriptions"
end

