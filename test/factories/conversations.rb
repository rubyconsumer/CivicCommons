# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conversation do |f|
  f.started_at ""
  f.finished_at ""
  f.summary "MyString"
  f.title "Some Randon Title"
  f.zip_code "48105"
  f.issues { |c| [c.association(:issue)] }
  f.from_community false
  f.association :owner, :factory => :admin_person
end

Factory.define :user_generated_conversation, :parent => :conversation do |f|
  f.contributions { |c| [c.association(:contribution)] }
  f.from_community true
  f.association :owner, :factory => :normal_person
end
