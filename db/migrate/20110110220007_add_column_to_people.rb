class AddColumnToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :bio, :text
  end

  def self.down
    remove_column :people, :bio
  end
end
