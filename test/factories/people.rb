# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :people do |f|
  Factory.define :normal_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
  end
  Factory.define :admin_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    u.admin true
  end  
end
