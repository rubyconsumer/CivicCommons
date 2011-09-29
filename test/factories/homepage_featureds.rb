# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :homepage_featured do |f|
  f.association :homepage_featureable, :factory => :conversation, :title => 'Homepage Featurable Title'
end
