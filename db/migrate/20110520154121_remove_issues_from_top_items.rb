class RemoveIssuesFromTopItems < ActiveRecord::Migration
  def self.up
    Activity.delete_all(item_type: 'Issue')
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Cannot load removed data"
  end
end
