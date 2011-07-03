class ShowProgressOnSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :show_progress, :boolean
  end

  def self.down
    remove_column :surveys, :show_progress
  end
end