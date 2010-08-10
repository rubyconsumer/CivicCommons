class AddDisplayTimeToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.datetime :display_time, :default=>Time.now
    end        
  end

  def self.down
    remove_column :posts, :display_time
  end
end
