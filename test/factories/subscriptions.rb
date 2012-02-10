# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :conversation_subscription, :class => Subscription do |f|
  f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
  f.association :subscribable, :factory => :conversation, :title => 'The Civic Commons'
end

Factory.define :issue_subscription, :class => Subscription do |f|
  f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
  f.association :subscribable, :factory => :issue, :summary => 'The Civic Commons'
end

Factory.define :organization_subscription, :class => Subscription do |f|
  f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
  f.association :subscribable, :factory => :organization
end


