# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :reflection do |f|
  f.association :owner, :factory => :person
  f.title 'Title here'
  f.details 'Details here'
  f.association :conversation
end

Factory.define :reflection_with_comments, :parent => :reflection do |f|
  f.comments { |reflection| [reflection.association(:reflection_comment)] }
end
