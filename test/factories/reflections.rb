# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define do
  factory :reflection do
    sequence(:title) {|n| "Reflection Title #{n}" }
    details "MyText"
    association :person, factory: :registered_user
    association :conversation, factory: :conversation
  end
end

Factory.define :reflection_with_comments, :parent => :reflection do |f|
  f.comments { |reflection| [reflection.association(:reflection_comment)] }
end
