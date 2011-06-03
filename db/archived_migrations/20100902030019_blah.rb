class Blah < ActiveRecord::Migration
  def self.up
    rename_column :contributions, :contribution_type, :type
  end

  def self.down
  end
end
