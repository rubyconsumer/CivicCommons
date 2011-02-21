class AddIndexToSubscriptions < ActiveRecord::Migration
  def self.up
    add_index :subscriptions, [:person_id, :subscribable_type, :subscribable_id], unique: true, name: 'unique-subs'
  end

  def self.down
    remove_index :subscriptions, name: 'unique-subs'
  end
end
