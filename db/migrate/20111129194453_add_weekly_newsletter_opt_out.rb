class AddWeeklyNewsletterOptOut < ActiveRecord::Migration
  def self.up
    add_column :people, :weekly_newsletter, :boolean, :default => true
  end

  def self.down
    remove_column :people, :weekly_newsletter
  end
end
