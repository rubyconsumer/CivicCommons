FactoryGirl.define do |f|
  factory :organization, :class => Organization do |o|
    o.name 'Leandog Inc'
    o.email 'leandog@leandog.com'
    o.password 'password'
    o.zip_code '44114'
    o.association :organization_detail, {
      street: '1100 N Marginal Ave',
      city: 'Cleveland',
      region: 'OH',
      postal_code: '44114',
      phone: '1-800-do-agile',
      facebook_page: 'http://www.facebook.com/leandogsoftware'
    }
    o.after_create do |oo|
      oo.authorized_to_setup_an_account = true
    end
  end
  
end