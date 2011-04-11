class AddEmbedlyCodeToContributions < ActiveRecord::Migration
  def self.up
    add_column :contributions, :embedly_code, :text
    add_column :contributions, :embedly_type, :string
  end

  def self.down
    remove_column :contributions, :embedly_type
    remove_column :contributions, :embedly_code
  end
end
