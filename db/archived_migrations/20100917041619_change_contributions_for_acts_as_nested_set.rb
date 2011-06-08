class ChangeContributionsForActsAsNestedSet < ActiveRecord::Migration
  def self.up
    rename_column :contributions, :contribution_id, :parent_id
    add_column :contributions, :lft, :integer
    add_column :contributions, :rgt, :integer
    Contribution.rebuild!
  end

  def self.down
    rename_column :contributions, :parent_id, :contribution_id
    remove_column :contributions, :lft
    remove_column :contributions, :rgt
  end
end
