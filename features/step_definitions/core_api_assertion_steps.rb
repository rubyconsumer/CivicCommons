Then /^I should receive the response:$/ do |expected|
  visit(@url)
  actual = page.body

  actual = "{}" if actual.strip.blank?

  JSON.parse(actual).should == JSON.parse(expected)
end

Then /^I should receive the contributions with data:$/ do |expected|

  defaults = {
    parent_title: "Understanding The Latest Health Care Changes",
    parent_type: "conversation",
    parent_url: "http://www.example.com/conversations/2",
    created_at: "2010-10-10T04:00:00Z",
    attachment_url: "",
    embed_code: "",
    link_text: "",
    link_url: ""
  }


  expected =  JSON.parse(expected).map do |item|
                item.merge(defaults)
              end


  visit(@url)
  actual = page.body

  actual = "{}" if actual.strip.blank?

  JSON.parse(actual).should == expected

end

Then /^I should receive a 404 Not Found response$/ do
  visit @url

  page.status_code.should == 404
end

Then /^I should the data in my response:$/ do |table|
  data = table.hashes


  template = <<-EOT
  {
    "parent_title": "Understanding The Latest Health Care Changes",
    "parent_type": "conversation",
    "parent_url": "http://www.example.com/conversations/2",
    "created_at": "2010-10-10T04:00:00Z",
    "content": "<comment>",
    "attachment_url": "",
    "embed_code": "",
    "type": "<type>",
    "link_text": "",
    "link_url": ""
  }
  EOT

  expected =  data.map do |comment|
                template.gsub(/<comment>/, comment['content']).
                         gsub(/<type>/, comment['type'])
              end.join(",")

  expected = "[#{expected}]"

  Then("I should receive the response:", expected)
end

