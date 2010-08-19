class AddRatingFieldsToPostables < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.integer :total_rating, :default=>0
      t.integer :recent_rating, :default=>0
      t.timestamp :last_rating_date
    end
    
    change_table :questions do |t|
      t.integer :total_rating, :default=>0
      t.integer :recent_rating, :default=>0
      t.timestamp :last_rating_date
    end
    
    change_table :conversations do |t|
      t.integer :total_rating, :default=>0
      t.integer :recent_rating, :default=>0
      t.timestamp :last_rating_date
    end
    
    change_table :events do |t|
      t.integer :total_rating, :default=>0
      t.integer :recent_rating, :default=>0
      t.timestamp :last_rating_date
    end
    
    change_table :issues do |t|
      t.integer :total_rating, :default=>0
      t.integer :recent_rating, :default=>0
      t.timestamp :last_rating_date
    end    
  end

  def self.down
    remove_column :comments, :total_rating
    remove_column :comments, :recent_rating
    remove_column :comments, :last_rating_date
    remove_column :questions, :total_rating
    remove_column :questions, :recent_rating
    remove_column :questions, :last_rating_date
    remove_column :conversations, :total_rating
    remove_column :conversations, :recent_rating
    remove_column :conversations, :last_rating_date
    remove_column :events, :total_rating
    remove_column :events, :recent_rating
    remove_column :events, :last_rating_date
    remove_column :issues, :total_rating
    remove_column :issues, :recent_rating
    remove_column :issues, :last_rating_date    
  end
end
