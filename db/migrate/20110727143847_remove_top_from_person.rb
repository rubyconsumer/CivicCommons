class RemoveTopFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :top
  end

  def self.down
    add_column :people, :top, :integer
  end
end
