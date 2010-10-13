# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :people do |f|
  Factory.define :normal_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    u.skip_shadow_account true
  end
  Factory.define :registered_user, :class => Person do |u|
    u.confirmed_at { Time.now }
    u.skip_shadow_account true
  end
  Factory.define :admin_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.admin.account#{n}@mysite.com" }
    u.admin true
    u.skip_shadow_account true
  end  

  Factory.define :person_with_shadow_account, :parent => :normal_person do |u|
    u.skip_shadow_account false
  end
end
