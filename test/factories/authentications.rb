# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :authentication do |f|
  f.provider "oauth"
  f.sequence(:uid) {|n| "#{n}" }
  f.token "token_here"
  f.secret "secret_here"
  f.association :person, :factory => :normal_person
end

Factory.define :facebook_authentication, :parent => :authentication do |f|
  f.provider "facebook"
end