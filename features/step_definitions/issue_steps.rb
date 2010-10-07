Given /^an issue:$/ do |table|

  issue = table.rows_hash

  @issue =
    Factory.create(:issue,
                   id:   issue['ID'],
                   name: issue['Name'],
                   summary: issue['Summary'],
                   zip_code: issue['Zip Code'])

  Factory.create(:top_level_contribution,
                 issue: @conversation)

end


Given /^I have a contribution on the issue$/ do
  Factory.create(:comment,
                 person: @current_person,
                 issue: @issue)
end


