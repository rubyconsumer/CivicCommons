Factory.define :people do |f|
  Factory.define :invalid_person, :class=>Person do |u|
    u.first_name ''
    u.last_name ''
    u.zip_code '44313'
    u.password 'password'
    u.email ''
    u.skip_email_marketing true
  end

  Factory.define :normal_person, :class=>Person do |u|
    u.first_name 'John'
    u.last_name 'Doe'
    u.zip_code '44313'
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    f.sequence(:cached_slug) {|n| "john-doe--#{n}" }
    u.skip_email_marketing true
    u.daily_digest false
    u.avatar_url '/images/avatar_70.gif'
  end

  Factory.define :registered_user, :parent => :normal_person do |u|
    u.confirmed_at { Time.now }
    u.skip_email_marketing true
  end

  Factory.define :registered_user_with_avatar, :parent => :registered_user do |u|
    u.avatar File.new(Rails.root + 'test/fixtures/images/test_image.jpg')
  end

  Factory.define :admin_person, :parent => :registered_user do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.admin.account#{n}@mysite.com" }
    u.sequence(:last_name) {|n| "Doe #{n}" }
    u.admin true
    u.skip_email_marketing true
    u.confirmed_at '2011-03-04 15:33:33'
  end

  Factory.define :marketable_person, :parent => :registered_user do |u|
    u.password 'password'
    u.sequence(:email) {|n| "test.account#{n}@mysite.com" }
    u.skip_email_marketing false
    u.marketable ""
  end

end
