class CreateReflectionPetition < ActiveRecord::Migration
  def self.up
    create_table :reflection_petitions, :force => true do |t|
      t.integer :reflection_id
      t.integer :petition_id
      t.timestamps
    end
    add_index :reflection_petitions, [:reflection_id, :petition_id]
  end

  def self.down
    remove_index :reflection_petitions, [:reflection_id, :petition_id]
    drop_table :reflection_petitions
  end
end
