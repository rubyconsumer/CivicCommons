class CreateAchievementStatistics < ActiveRecord::Migration
  def self.up
    create_table :achievement_statistics do |t|
      t.integer :person_id
      t.integer :achievement_metadata_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :achievement_statistics
  end
end
