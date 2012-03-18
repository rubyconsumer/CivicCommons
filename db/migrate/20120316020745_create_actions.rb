class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions, :force => true do |t|
      t.integer :conversation_id
      t.integer :actionable_id
      t.string :actionable_type
      t.timestamps
    end
    add_index :actions, :actionable_id
    add_index :actions, :actionable_type
    add_index :actions, :conversation_id
  end

  def self.down
    remove_index :actions, :conversation_id
    remove_index :actions, :actionable_type
    remove_index :actions, :actionable_id
    drop_table :actions
  end
end