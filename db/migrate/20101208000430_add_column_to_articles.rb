class AddColumnToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :youtube_id, :string
  end

  def self.down
    remove_column :articles, :youtube_id
  end
end
