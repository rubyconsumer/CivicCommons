class AddConfirmedToContributions < ActiveRecord::Migration
  def self.up
    add_column :contributions, :confirmed, :boolean, :default => true
  end

  def self.down
    remove_column :contributions, :confirmed
  end
end
