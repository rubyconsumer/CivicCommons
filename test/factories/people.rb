# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :people do |f|
  Factory.define :normal_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    u.avatar File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
    u.skip_invite true
    u.skip_shadow_account true
    u.skip_email_marketing true
  end

  Factory.define :registered_user, :class => Person do |u|
    u.confirmed_at { Time.now }
    u.avatar {File.new(Rails.root + 'test/fixtures/images/test_image.jpg')}
    u.skip_invite true
    u.skip_shadow_account true
    u.skip_email_marketing true
  end

  Factory.define :admin_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.admin.account#{n}@mysite.com" }
    u.admin true
    u.avatar File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
    u.skip_invite true
    u.skip_shadow_account true
    u.skip_email_marketing true
  end

  Factory.define :person_with_shadow_account, :parent => :normal_person do |u|
    u.skip_shadow_account false
  end

  Factory.define :marketable_person, :class=>Person do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    u.avatar File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
    u.skip_invite true
    u.skip_shadow_account true
    u.skip_email_marketing false
    u.marketable ""
  end

end
