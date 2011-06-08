class DropUnusedTables < ActiveRecord::Migration
  def self.up

    drop_table :conversations_events
    drop_table :conversations_guides

  end

  def self.down

    create_table "conversations_events", :id => false do |t|
      t.integer "conversation_id"
      t.integer "event_id"
    end

    create_table "conversations_guides", :id => false do |t|
      t.integer "conversation_id"
      t.integer "guide_id"
    end

  end
end
