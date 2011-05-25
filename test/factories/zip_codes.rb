# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :zip_code do |f|
  f.association :region, :factory => :region
  f.zip_code "11111"
end
