class RemoveUnusedEventsTables < ActiveRecord::Migration
  def self.up
    drop_table :events
    drop_table :events_guides
  end

  def self.down
    create_table :events do |t|
      t.string :title
      t.datetime :when
      t.string :where
      t.integer :moderator_id

      t.timestamps
    end

    create_table :events_guides, :id => false do |t|
      t.integer :event_id
      t.integer :guide_id
    end
  end
end

