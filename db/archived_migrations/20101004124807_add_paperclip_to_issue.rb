class AddPaperclipToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :image_file_name, :string # Original filename
    add_column :issues, :image_content_type, :string # Mime type
    add_column :issues, :image_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :issues, :image_file_name
    remove_column :issues, :image_content_type
    remove_column :issues, :image_file_size
  end
end
