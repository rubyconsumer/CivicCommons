Factory.define :managed_issue_page do |f|
  f.name "Big, Important Issue"
  f.template "Big honkin' blob of HTML..."
  f.association :issue, :factory => :managed_issue
  f.association :author, :factory => :admin_person
end
