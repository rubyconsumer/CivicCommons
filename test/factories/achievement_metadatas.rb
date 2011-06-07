# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :achievement_metadata_bronze, :class =>AchievementMetadata do |f|
  f.title "Bronze Achievment"
  f.description "MyText"
  f.points 1
  f.threshold 1
end

Factory.define :achievement_metadata_silver, :class =>AchievementMetadata do |f|
  f.title "Silver Achievment"
  f.description "MyText"
  f.points 5
  f.threshold 10
end

Factory.define :achievement_metadata_gold, :class =>AchievementMetadata do |f|
  f.title "Gold Achievment"
  f.description "MyText"
  f.points 10
  f.threshold 50
end

Factory.define :achievement_metadata_t3, :class =>AchievementMetadata do |f|
  f.title "Threshold 3 Achievement"
  f.description "MyText"
  f.points 1
  f.threshold 3
end

Factory.define :achievement_metadata, :class =>AchievementMetadata do |f|
  f.title "MyString"
  f.description "MyText"
  f.points 1
  f.threshold 1
end
