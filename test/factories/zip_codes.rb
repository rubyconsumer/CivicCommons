# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :zip_code do |f|
  f.region_id 1
  f.zip_code "MyString"
end
