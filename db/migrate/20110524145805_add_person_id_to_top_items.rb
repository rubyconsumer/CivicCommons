class AddPersonIdToTopItems < ActiveRecord::Migration
  def self.up
    add_column :top_items, :person_id, :integer
    add_index :top_items, :person_id, name: 'person_index'
  end

  def self.down
    remove_column :top_items, :person_id
    remove_index :top_items, :person_index
  end
end
