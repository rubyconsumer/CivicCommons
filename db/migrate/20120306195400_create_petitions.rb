class CreatePetitions < ActiveRecord::Migration
  def self.up
    create_table :petitions, :force => true do |t|
      t.integer :conversation_id
      t.string :title
      t.text :description
      t.text :resulting_actions
      t.integer :signature_needed
      t.date :end_on
      t.timestamps
    end
    add_index :petitions, :conversation_id
    
    create_table :petition_signatures, :force => true do |t|
      t.integer :petition_id
      t.integer :person_id
      t.timestamps
    end
    add_index :petition_signatures, [:petition_id, :person_id]
  end

  def self.down
    remove_index :petition_signatures, [:petition_id, :person_id]
    drop_table :petition_signatures
    remove_index :petitions, :conversation_id
    drop_table :petitions
  end
end