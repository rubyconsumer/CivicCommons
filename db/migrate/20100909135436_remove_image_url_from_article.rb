class RemoveImageUrlFromArticle < ActiveRecord::Migration
  def self.up
    remove_column :articles, :image_url
  end

  def self.down
    add_column :articles, :image_url, :string
  end
end