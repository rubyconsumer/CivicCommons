# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :people do |f|
  Factory.define :normal_person, :class=>Person do |u|
    u.password 'password'
    u.email 'test.account@mysite.com'
  end
  Factory.define :admin_person, :class=>Person do |u|
    u.password 'password'
    u.email 'test.account@mysite.com'
    u.admin true
  end  
end
