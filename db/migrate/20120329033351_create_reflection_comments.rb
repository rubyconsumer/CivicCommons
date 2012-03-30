class CreateReflectionComments < ActiveRecord::Migration
  def self.up
    create_table :reflection_comments do |t|
      t.text :body
      t.integer :person_id
      t.integer :reflection_id

      t.timestamps
    end
    add_index :reflection_comments, :reflection_id
    add_index :reflection_comments, :person_id
  end

  def self.down
    remove_index :reflection_comments, :person_id
    remove_index :reflection_comments, :reflection_id
    mind
    drop_table :reflection_comments
  end
end