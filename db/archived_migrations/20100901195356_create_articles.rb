class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :link
      t.string :image_url
      t.string :video_url
      t.string :percent
      t.boolean :current
      t.boolean :main

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
