class CreateMetroRegions < ActiveRecord::Migration
  def self.up
    create_table :metro_regions do |t|
      t.string :province
      t.string :city_name
      t.string :criteria_id
      t.string :metro_name
      t.string :display_name
      t.string :metrocode
      t.string :province_code

      t.timestamps
    end
  end

  def self.down
    drop_table :metro_regions
  end
end
