class MetroRegionTokenCol < ActiveRecord::Migration
  def up
    add_column :metro_regions, :city_province_token, :string
    add_index :metro_regions, :city_province_token
  end

  def down
    remove_index :metro_regions, :city_province_token
    remove_column :metro_regions, :city_province_token
  end
end