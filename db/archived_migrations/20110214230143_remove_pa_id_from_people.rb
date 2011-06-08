class RemovePaIdFromPeople < ActiveRecord::Migration
  def self.up
    remove_index :people, name: :pa_id_index
    remove_column :people, :people_aggregator_id
  end

  def self.down
    add_column :people, :people_aggregator_id, :integer
    add_index :people, :people_aggregator_id, name: 'pa_id_index', unique: true
  end
end
