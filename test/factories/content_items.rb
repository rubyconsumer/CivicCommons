Factory.define :content_item do |f|
  f.association :author, :factory => :admin_person
  f.content_type "Untyped"
  f.title "Untyped post 1"
  f.cached_slug "post-1"
  f.summary "This is a post about this and that"
  f.body "This is a post about this and that and this where that is now and this is then."
  f.created_at "2011-03-11 12:25:10"
  f.published Date.today
end

# person_id`, `content_type`, `title`, `url`, `summary`, `body`, `created_at`, `updated_at`
