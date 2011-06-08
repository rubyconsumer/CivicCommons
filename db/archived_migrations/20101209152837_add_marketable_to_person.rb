class AddMarketableToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :marketable, :boolean
    add_column :people, :marketable_at, :datetime
  end

  def self.down
    remove_column :people, :marketable_at
    remove_column :people, :marketable
  end
end