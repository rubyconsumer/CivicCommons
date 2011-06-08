class RemoveValidatedColumnFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :validated
  end

  def self.down
    add_column :people, :validated, :boolean
  end
end
