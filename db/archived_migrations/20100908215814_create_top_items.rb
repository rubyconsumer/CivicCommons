class CreateTopItems < ActiveRecord::Migration
  def self.up
    create_table :top_items do |t|
      t.references :item, :polymorphic=>true
      t.datetime :item_created_at
      t.decimal :recent_rating, :precision => 3, :scale => 2
      t.integer :recent_visits
    end
    
    items = []
    
    [Conversation,Contribution,Issue].collect{ |o| items = items | o.all }
    
    items.sort_by{ |i| i.created_at }.each do |item|
      TopItem.create(:item => item, :item_created_at => item.created_at, :recent_rating => (item.calculate_recent_rating if item.respond_to?(:ratings)), :recent_visits => (item.calculate_recent_visits if item.respond_to?(:visits)))
    end
    
  end

  def self.down
    drop_table :top_items
  end
end
