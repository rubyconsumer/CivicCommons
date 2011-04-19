# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :managed_issue_page_history do |f|
  f.issue_page_id 1
  f.created_by 1
  f.content "MyText"
end