class PetitionCreator < ActiveRecord::Migration
  def self.up
    add_column :petitions, :person_id, :integer
    add_index :petitions, :person_id
  end

  def self.down
    remove_index :petitions, :person_id
    remove_column :petitions, :person_id
  end
end