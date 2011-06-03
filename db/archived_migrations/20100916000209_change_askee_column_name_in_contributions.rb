class ChangeAskeeColumnNameInContributions < ActiveRecord::Migration
  def self.up
    remove_column :contributions, :target_person_id
    add_column :contributions, :askee, :string
  end

  def self.down
    remove_column :contributions, :askee
    add_column :contributions, :target_person_id, :integer
  end
end
