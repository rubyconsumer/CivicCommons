class CreateConversationsEvents < ActiveRecord::Migration
  def self.up
    create_table :conversations_events, :id => false do |t|
      t.references :conversation, :event
    end
  end

  def self.down
    drop_table :conversations_events
  end
end
