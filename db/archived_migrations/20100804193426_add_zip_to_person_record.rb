class AddZipToPersonRecord < ActiveRecord::Migration
  def self.up
    add_column :people, :zip_code, :string, :length => 10
  end

  def self.down
    remove_column :people, zip_code
  end
end
