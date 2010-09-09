class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.integer :region_id
      t.string :zip_code

      t.timestamps
    end
  end

  def self.down
    drop_table :zip_codes
  end
end
