class AddPeopleAggregatorIdToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :people_aggregator_id, :integer
  end

  def self.down
    remove_column :people, :people_aggregator_id
  end
end