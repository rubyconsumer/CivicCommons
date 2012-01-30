class CreateContentItemDescriptionTable < ActiveRecord::Migration
  def self.up
    create_table :content_item_descriptions do |t|
      t.string :content_type
      t.text :description_long
      t.text :description_short
    end
  end

  def self.down
    drop_table :content_item_descriptions
  end
end
