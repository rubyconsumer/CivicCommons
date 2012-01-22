class ContentItemsPeople < ActiveRecord::Migration
  def self.up
    create_table :content_items_people, :force => true, :id => false do |t|
      t.integer :content_item_id
      t.integer :person_id
      t.string :role
      t.timestamps
    end
    add_index :content_items_people, [:content_item_id, :person_id]
  end

  def self.down
    remove_index :content_items_people, [:content_item_id, :person_id]
    drop_table :content_items_people
  end
end
