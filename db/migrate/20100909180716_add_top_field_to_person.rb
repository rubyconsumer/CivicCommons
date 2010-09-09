class AddTopFieldToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :top, :integer
  end

  def self.down
    remove_column :people, :top
  end
end