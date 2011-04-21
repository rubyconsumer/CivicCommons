Factory.define :issue do |f|
  f.name "Really Important Stuff"
  f.created_at 3.months.ago
  f.updated_at 3.months.ago
  f.summary "All the important stuff happening in our region."
  f.url_title "really_important_stuff"
  f.total_visits 0
  f.recent_visits 0
  f.last_visit_date nil
  f.zip_code '44313'
  f.type 'Issue'
end

Factory.define :managed_issue, :parent => :issue do |f|
  f.managed_issue_page_id nil
  f.type 'ManagedIssue'
  #f.association :index_page, :factory => :managed_issue_page
end
