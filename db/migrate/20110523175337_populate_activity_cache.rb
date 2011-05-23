class PopulateActivityCache < ActiveRecord::Migration
  def self.up
    Activity.all.each do |activity_item|
      activity_item.activity_cache = Activity.encode(activity_item.item)
      activity_item.save
    end
  end

  def self.down
    Activity.update_all(activity_cache: nil)
  end
end
