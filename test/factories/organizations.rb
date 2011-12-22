FactoryGirl.define do |f|
  factory :organization, :class => Organization do |o|
    o.name 'The Civic Commons'
    o.email 'us@theciviccommons.com'
    o.password 'password'
    o.zip_code '44115'
    o.association :organization_detail, {
      street: '2254 Euclid Avenue',
      city: 'Cleveland',
      region: 'OH',
      postal_code: '44115',
      phone: '800-530-8507',
      facebook_page: 'https://www.facebook.com/pages/The-Civic-Commons/139623022730390'
    }
    o.after_create do |oo|
      oo.authorized_to_setup_an_account = true
    end
  end
  factory :newly_confirmed_organization, :parent => :organization do |o|
    o.confirmed_at { Time.now }
    o.skip_email_marketing true
  end
end
