class AddColumnsToConversations < ActiveRecord::Migration
  def self.up
    change_table :conversations do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end
  end

  def self.down
    change_table :conversations do |t|
      t.remove :total_visits
      t.remove :recent_visits
      t.remove :last_visit_date
    end
  end
end
