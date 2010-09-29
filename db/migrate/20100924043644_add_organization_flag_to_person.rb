class AddOrganizationFlagToPerson < ActiveRecord::Migration
  def self.up
    add_column(:people, :organization, :boolean, :default => false)
  end

  def self.down
    remove_column(:people, :organization)
  end
end
