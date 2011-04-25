class CreateContentTemplates < ActiveRecord::Migration
  def self.up
    create_table :content_templates do |t|
      t.string :name
      t.text :template
      t.integer :person_id
      t.string :cached_slug

      t.timestamps
    end

    add_index  :content_templates, :cached_slug, :unique => true
  end

  def self.down
    drop_table :content_templates
  end
end
