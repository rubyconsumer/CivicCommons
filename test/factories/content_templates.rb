Factory.define :content_template do |f|
  f.association :author, :factory => :admin_person
  f.name "Blog Post Template"
  f.template "Lorem ipsum..."
  f.person_id 1
  f.cached_slug "blog-post-template"
  f.created_at 1.week.ago
end
