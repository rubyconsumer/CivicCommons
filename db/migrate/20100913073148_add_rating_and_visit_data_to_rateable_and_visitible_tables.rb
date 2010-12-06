class AddRatingAndVisitDataToRateableAndVisitibleTables < ActiveRecord::Migration
  def self.up
    [:contributions, :conversations, :issues].each do |table|
      [:total_visits, :recent_visits, :total_rating, :recent_rating].each do |column|
        add_column table, column, :integer unless table.to_s.classify.constantize.column_names.include?(column.to_s)
      end
      [:last_visit_date, :last_rating_date].each do |column|
        add_column table, column, :datetime unless table.to_s.classify.constantize.column_names.include?(column.to_s)
      end
    end
  end

  def self.down
  end
end
