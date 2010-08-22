class RenameParentFieldsToRateableFieldsOnRating < ActiveRecord::Migration
  def self.up
    change_table :ratings do |t|
      t.references :rateable, :polymorphic=>true                  
    end    
    remove_column :ratings, :parent_id
    remove_column :ratings, :parent_type        
  end

  def self.down
    remove_column :ratings, :rateable_id
    remove_column :ratings, :rateable_type        
    
    change_table :ratings do |t|
      t.integer :parent_type
      t.integer :parent_id
    end        
  end
end
