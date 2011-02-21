class RemoveRatingsTable < ActiveRecord::Migration
  def self.up
    drop_table :ratings
  end

  def self.down
    create_table :ratings do |t|
      t.integer :person_id
      t.integer :rating
      t.integer :rateable_id
      t.integer :rateable_type
      t.timestamps
    end
  end
end
