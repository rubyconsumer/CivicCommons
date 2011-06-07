class AchievementEarned < ActiveRecord::Base
  belongs_to :person
  belongs_to :achievement_metadata
  validates :achievement_metadata, :presence => true
  validates :person, :presence => true
  validates_uniqueness_of :achievement_metadata_id, :scope => :person_id
end
