class AddPostToComments < ActiveRecord::Migration
  def self.up
    change_table(:comments) do |t|
      t.remove :parent_id
      t.remove :parent_type
    end
  end

  def self.down
    change_table(:comments) do |t|
      t.integer :parent_type
      t.integer :parent_id      
    end    
  end
end
