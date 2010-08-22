class AddVisitsFieldsToPostable < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end
    
    change_table :questions do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end
    
    change_table :conversations do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end
    
    change_table :events do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end
    
    change_table :issues do |t|
      t.integer :total_visits, :default=>0
      t.integer :recent_visits, :default=>0
      t.timestamp :last_visit_date
    end    
  end

  def self.down
    remove_column :comments, :total_visits
    remove_column :comments, :recent_visits
    remove_column :comments, :last_visit_date
    remove_column :questions, :total_visits
    remove_column :questions, :recent_visits
    remove_column :questions, :last_visit_date
    remove_column :conversations, :total_visits
    remove_column :conversations, :recent_visits
    remove_column :conversations, :last_visit_date
    remove_column :events, :total_visits
    remove_column :events, :recent_visits
    remove_column :events, :last_visit_date
    remove_column :issues, :total_visits
    remove_column :issues, :recent_visits
    remove_column :issues, :last_visit_date    
  end
end
