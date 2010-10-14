class AddDescriptionColumnToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :description, :text
  end

  def self.down
    remove_column :regions, :description
  end
end
