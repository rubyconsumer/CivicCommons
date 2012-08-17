class AddRegionToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :people, :default_region, :integer
  end
  def self.down
    remove_column :people, :default_region
  end
end
