class CreateOrganizationDetails < ActiveRecord::Migration
  def self.up
    create_table :organization_details do |t|
      t.integer :person_id
      t.string :street
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :phone
      t.string :facebook_page
      t.references :organization
      t.timestamps

    end
  end

  def self.down
    drop_table :organization_details
  end
end
