class AddHomepageFeaturedModel < ActiveRecord::Migration
  def self.up
    create_table :homepage_featureds do |t|
      t.references :homepage_featureable, polymorphic: true, null: false, unique: true
      t.timestamps
    end
    add_index :homepage_featureds, [:homepage_featureable_id, :homepage_featureable_type], name: 'homepage_featureable_id_and_type', unique: true
  end

  def self.down
    remove_index :homepage_featureds, name: 'homepage_featureable_id_and_type'
    drop_table :homepage_featureds
  end
end
