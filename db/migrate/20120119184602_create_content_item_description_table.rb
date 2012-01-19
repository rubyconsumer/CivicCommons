class CreateContentItemDescriptionTable < ActiveRecord::Migration
  def self.up
    create_table :content_item_descriptions do |t|
      t.string :content_type
      t.string :description_long
      t.string :description_short
    end
  end

  def self.down
    drop_table :content_item_descriptions
  end
end
