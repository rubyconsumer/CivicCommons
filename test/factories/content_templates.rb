Factory.define :content_template do |f|
  f.association :author, :factory => :admin_person
  f.sequence(:name) {|n| "Sample Template #{n}" }
  f.template "Lorem ipsum..."
  f.sequence(:cached_slug) {|n| "sample-template-#{n}" }
  f.created_at 1.week.ago
end
