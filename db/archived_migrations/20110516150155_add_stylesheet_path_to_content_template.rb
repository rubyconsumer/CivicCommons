class AddStylesheetPathToContentTemplate < ActiveRecord::Migration
  def self.up
    add_column :content_templates, :stylesheet_path, :string
  end

  def self.down
    remove_column :content_templates, :stylesheet_path
  end
end
