class ChangeToReflectionActions < ActiveRecord::Migration
  def self.up
    remove_index :reflection_petitions, [:reflection_id, :petition_id]
    drop_table :reflection_petitions
    
    create_table :actions_reflections, :id => false, :force => true do |t|
      t.integer :reflection_id
      t.integer :action_id
    end
    add_index :actions_reflections, [:reflection_id, :action_id]
  end

  def self.down
    remove_index :actions_reflections, [:reflection_id, :action_id]
    drop_table :actions_reflections
    
    create_table :reflection_petitions, :force => true do |t|
      t.integer :reflection_id
      t.integer :petition_id
      t.timestamps
    end
    add_index :reflection_petitions, [:reflection_id, :petition_id]
  end
end