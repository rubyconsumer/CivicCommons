class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name
      t.string :state, :limit => 2
      t.integer :region_id
      t.timestamps
    end
    add_index :counties, :region_id
  end

  def self.down
    drop_table :counties
  end
end
