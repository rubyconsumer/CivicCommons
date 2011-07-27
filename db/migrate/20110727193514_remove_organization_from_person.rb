class RemoveOrganizationFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :organization
  end

  def self.down
    add_column :people, :organization, :boolean, :default => false
  end
end
