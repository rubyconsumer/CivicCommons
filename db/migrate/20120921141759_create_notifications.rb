class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :person_id
      t.integer :item_id
      t.string :item_type
      t.string :status
      t.datetime :viewed_at
      t.datetime :expire_at

      t.timestamps
    end
  end
end
