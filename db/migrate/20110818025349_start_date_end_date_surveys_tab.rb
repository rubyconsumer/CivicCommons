class StartDateEndDateSurveysTab < ActiveRecord::Migration
  def self.up
    add_column :surveys, :start_date, :date
    add_column :surveys, :end_date, :date
  end

  def self.down
    remove_column :surveys, :end_date
    remove_column :surveys, :start_date
  end
end