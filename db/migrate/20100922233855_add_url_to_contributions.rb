class AddUrlToContributions < ActiveRecord::Migration
  def self.up
    add_column :contributions, :url, :string
    add_column :contributions, :title, :string
    add_column :contributions, :description, :text
    add_column :contributions, :embed_target, :string
  end

  def self.down
    remove_column :contributions, :url
    remove_column :contributions, :title
    remove_column :contributions, :description
    remove_column :contributions, :embed_target
  end
end
