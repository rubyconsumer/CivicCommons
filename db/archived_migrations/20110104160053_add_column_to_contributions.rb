class AddColumnToContributions < ActiveRecord::Migration
  def self.up
    add_column :contributions, :notify, :boolean
  end

  def self.down
    remove_column :contributions, :notify
  end
end
