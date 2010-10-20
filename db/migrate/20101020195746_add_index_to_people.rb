class AddIndexToPeople < ActiveRecord::Migration
  def self.up
    add_index :people, :people_aggregator_id, :name => 'pa_id_index', :unique => true
  end

  def self.down
    remove_index :people, :pa_id_index
  end
end
