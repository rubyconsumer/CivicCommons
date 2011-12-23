class OrganizationMembers < ActiveRecord::Migration
  def self.up
    create_table :organization_members, :force => true, :id => false do |t|
      t.integer :organization_id
      t.integer :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :organization_members
  end
end


