class Topics < ActiveRecord::Migration
  def self.up
    create_table :topics, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end