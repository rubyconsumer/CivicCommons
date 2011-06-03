class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :person_id
      t.string :invitation_token, :limit => 40
      t.datetime :invitation_sent_at
      t.boolean :valid_invite
      t.string :email, :limit => 255

      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
