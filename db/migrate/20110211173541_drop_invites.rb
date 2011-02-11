class DropInvites < ActiveRecord::Migration
  def self.up
    drop_table :invites
  end

  def self.down
    create_table :invites do |t|
      t.integer :person_id
      t.string  :invitation_token, limit: 40
      t.datetime :invitation_sent_at
      t.boolean :valid_invite
      t.string :email
      t.timestamps
    end
  end
end
