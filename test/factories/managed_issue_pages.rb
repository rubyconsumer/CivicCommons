Factory.define :managed_issue_page do |f|
  f.association :issue, :factory => :managed_issue
  f.title "Big, Important Issue"
  f.url_title "big_important_id"
  f.association :created_by, :factory => :admin_person
  f.content "Big honkin' blob of HTML..."
end
