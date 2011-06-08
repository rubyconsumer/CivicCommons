class AddZipCodetoIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :zip_code, :string
  end

  def self.down
    remove_column :issues, :zip_code
  end
end
