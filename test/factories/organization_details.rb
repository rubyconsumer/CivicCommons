# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_detail do
      street '2254 Euclid Avenue'
      city 'Cleveland'
      region 'OH'
      postal_code '44115'
      phone '800-530-8507'
      facebook_page 'https://www.facebook.com/pages/The-Civic-Commons/139623022730390'
    end
end
