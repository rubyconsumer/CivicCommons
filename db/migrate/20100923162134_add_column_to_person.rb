class AddColumnToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :proxy, :boolean
  end

  def self.down
    remove_column :people, :proxy
  end
end
