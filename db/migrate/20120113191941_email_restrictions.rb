class EmailRestrictions < ActiveRecord::Migration
  def self.up
    create_table :email_restrictions, :force => true do |t|
      t.string :domain
      t.timestamps
    end
  end

  def self.down
    drop_table :email_restrictions
  end
end