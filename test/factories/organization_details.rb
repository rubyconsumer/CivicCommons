# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_detail do
      street "MyString"
      city "MyString"
      region "MyString"
      postal_code "MyString"
      phone "MyString"
      facebook_page "MyString"
    end
end