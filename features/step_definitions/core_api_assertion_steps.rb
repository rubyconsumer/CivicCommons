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

