class MakeIssueColumnsIntuitive < ActiveRecord::Migration
  def self.up
    # The name of the issue
    rename_column(:issues, :description, :name)
    # summary describing issue should be a blob
    change_column(:issues, :summary, :text)
  end

  def self.down
    rename_column(:issues, :name, :description)
    change_column(:issues, :summary, :string)
  end
end
