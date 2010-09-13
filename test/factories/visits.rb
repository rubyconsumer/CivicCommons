# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :visit do |f|
  f.association :person, :factory => :normal_person
end
