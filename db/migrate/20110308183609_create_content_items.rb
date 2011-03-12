class CreateContentItems < ActiveRecord::Migration
  def self.up
    create_table :content_items do |t|
      t.integer :person_id
      t.string :content_type
      t.string :title, :null => false
      t.string :url, :null => false
      t.text :summary
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :content_items
  end
end
