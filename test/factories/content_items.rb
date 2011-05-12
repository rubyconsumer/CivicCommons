Factory.define :content_item do |f|
  f.content_type "BlogPost"
  f.sequence(:title) {|n| "Content Item #{n}" }
  f.sequence(:cached_slug) {|n| "content-item-#{n}" }
  f.summary "This is a post about this and that"
  f.body "This is a post about this and that and this where that is now and this is then."
  f.created_at 10.days.ago
  f.published 1.day.ago.strftime("%m/%d/%Y")
  f.association :author, :factory => :admin_person
end

Factory.define :blog_post, :parent => :content_item do |f|
  f.content_type "BlogPost"
  f.sequence(:title) {|n| "Blog Post #{n}" }
  f.sequence(:cached_slug) {|n| "blog-post-#{n}" }
end

Factory.define :news_item, :parent => :content_item do |f|
  f.content_type "NewsItem"
  f.external_link "http://www.theciviccommons.com"
  f.sequence(:title) {|n| "News Item #{n}" }
  f.sequence(:cached_slug) {|n| "news-item-#{n}" }
end

Factory.define :radio_show, :parent => :content_item do |f|
  f.content_type "RadioShow"
  f.embed_code "Embed this, baby!"
  f.external_link "http://www.theciviccommons.com/podcast.mp3"
  f.sequence(:title) {|n| "Radio Show #{n}" }
  f.sequence(:cached_slug) {|n| "radio-show-#{n}" }
end
