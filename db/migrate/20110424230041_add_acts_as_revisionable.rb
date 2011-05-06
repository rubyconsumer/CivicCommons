class AddActsAsRevisionable < ActiveRecord::Migration
  def self.up
    ActsAsRevisionable::RevisionRecord.create_table
  end

  def self.down
    drop_table :revision_records
  end
end
