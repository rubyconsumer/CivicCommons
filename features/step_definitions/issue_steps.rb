Given /^an issue:$/ do |table|

  issue = table.rows_hash

  attachment = File.join(attachments_path, issue['Image'])

  @issue =
    Factory.create(:issue,
                   id:   issue['ID'],
                   name: issue['Name'],
                   image: File.open(attachment),
                   summary: issue['Summary'],
                   zip_code: issue['Zip Code'])

  Factory.create(:top_level_contribution,
                 issue: @issue)

end


Given /^I have a contribution on the issue$/ do
  Factory.create(:comment,
                 person: @current_person,
                 issue: @issue)
end


