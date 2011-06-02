class UpdateConversationTextFields < ActiveRecord::Migration
  def self.up
    change_column :conversations, :summary, :text
  end

  def self.down
    change_column :conversations, :summary, :string
  end
end
