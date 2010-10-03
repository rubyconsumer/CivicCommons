# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conversation do |f|
  f.started_at ""
  f.finished_at ""
  f.moderator_id "1"
  f.summary "MyString"
  f.title "Some Randon Title"
end
