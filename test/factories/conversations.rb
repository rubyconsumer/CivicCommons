# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conversation do |f|
  f.started_at ""
  f.finished_at ""
  f.summary "MyString"
  f.title "Some Randon Title"
end

Factory.define :user_generated_conversation, :parent => :conversation do |f|
  f.user_generated true
  f.association :person, :factory => :normal_person
end
