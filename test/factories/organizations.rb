FactoryGirl.define do |f|
  factory :organization, :class => Organization do |o|
    o.name 'The Civic Commons'
    o.sequence(:email) {|i| "us#{i}@theciviccommons.com"}
    o.password 'password'
    o.zip_code '44115'
    o.association :organization_detail
    o.after_create do |oo|
      oo.authorized_to_setup_an_account = true
    end
    o.website "http://theciviccommons.com"
    o.twitter_username 'theciviccommons'
  end
  factory :newly_confirmed_organization, :parent => :organization do |o|
    o.confirmed_at { Time.now }
    o.skip_email_marketing true
  end
end
