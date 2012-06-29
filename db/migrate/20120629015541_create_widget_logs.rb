class CreateWidgetLogs < ActiveRecord::Migration
  def self.up
    create_table :widget_logs do |t|
      t.text :remote_url
      t.string :url
      t.datetime :created_at
    end
    add_index :widget_logs, :url
  end

  def self.down
    remove_index :widget_logs, :url
    drop_table :widget_logs
  end
end