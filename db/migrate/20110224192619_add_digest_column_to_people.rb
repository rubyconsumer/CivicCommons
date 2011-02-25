class AddDigestColumnToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :daily_digest, :boolean, default: true, null: false
  end

  def self.down
    remove_column :people, :daily_digest
  end
end
