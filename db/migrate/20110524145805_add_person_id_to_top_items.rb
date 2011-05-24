class AddPersonIdToTopItems < ActiveRecord::Migration
  def self.up
    add_column :top_items, :person_id, :integer
  end

  def self.down
    remove_column :top_items, :person_id
  end
end
