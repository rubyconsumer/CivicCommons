# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :contribution do |f|
  f.datetime "2010-06-30 12:39:43"
  f.owner 1
  f.content "MyText"
end

Factory.define :comment do |f|
  f.datetime "2010-06-30 12:39:43"
  f.owner 1
  f.content "MyText"
end