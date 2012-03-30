# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :reflection_comment do |f|
  f.body 'Body comment here'
  f.association(:person)
  f.association(:reflection)
end
