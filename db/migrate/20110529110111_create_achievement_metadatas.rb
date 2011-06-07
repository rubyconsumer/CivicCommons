class CreateAchievementMetadatas < ActiveRecord::Migration
  def self.up
    create_table :achievement_metadatas do |t|
      t.string :title
      t.text :description
      t.integer :points
      t.integer :threshold
      t.string :badge_file_name
      t.string :badge_content_type
      t.integer :badge_file_size
      t.datetime :badge_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :achievement_metadatas
  end
end
