class AddStaffPickToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :staff_pick, :boolean, default: false, null: false
  end

  def self.down
    remove_column :conversations, :staff_pick
  end
end
