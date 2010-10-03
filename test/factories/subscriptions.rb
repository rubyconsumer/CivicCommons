# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :subscription do |f|
  f.association :person, :factory => :normal_person, :first_name => 'Marc', :last_name => 'Canter'
  f.association :subscribable, :factory => :conversation, :title => 'Civic Commons'
end
