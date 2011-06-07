# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :achievement_statistic do |f|
  f.person_id 1
  f.achievement_metadata_id 1
  f.current_count 1
end