class AddLockableToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.lockable
    end
  end

  def self.down
    # Anyone know how to reverse devise migrations?
  end
end
