class AddSummaryFieldToIssues < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.string :summary
    end
  end

  def self.down
    change_table :issues do |t|
      t.remove :summary
    end
  end
end
