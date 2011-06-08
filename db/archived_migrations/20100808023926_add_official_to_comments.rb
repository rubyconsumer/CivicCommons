class AddOfficialToComments < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.boolean :official, :default=>false
    end    
  end

  def self.down
    remove_column :comments, :official
  end
end
