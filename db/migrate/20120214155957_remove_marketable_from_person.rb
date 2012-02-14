class RemoveMarketableFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :marketable_at
    remove_column :people, :marketable
  end

  def self.down
    add_column :people, :marketable, :boolean
    add_column :people, :marketable_at, :datetime
  end
end
