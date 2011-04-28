Factory.define :managed_issue_page do |f|
  f.sequence(:name) {|n| "Big, Important Issue #{n}" }
  f.sequence(:cached_slug) {|n| "big-important-issue-#{n}" }
  f.template "Big honkin' blob of CCML..."
  f.created_at 1.week.ago
  f.association :issue, :factory => :managed_issue
  f.association :author, :factory => :admin_person
end
