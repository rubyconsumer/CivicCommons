# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :top_level_contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :owner, :factory => :normal_person
  f.content "MyText"
  f.type "TopLevelContribution"
end

Factory.define :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :owner, :factory => :normal_person
  f.content "MyText"
  f.association :parent, :factory => :top_level_contribution
end

Factory.define :comment do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :owner, :factory => :normal_person
  f.content "MyText"
  f.association :parent, :factory => :top_level_contribution
end

Factory.define :question do |f|
  f.datetime "2010-06-30 12:39:43"
  f.association :owner, :factory => :normal_person
  f.content "MyText?"
  f.association :parent, :factory => :top_level_contribution
end