class DestroyAllTopLevelContributionTopItems < ActiveRecord::Migration
  def self.up
    TopItem.includes(:item).all.each do |ti|
      item = ti.item
      if item.not_top_itemable? && ti.destroy
        puts "Deleted TopItem for #{item} (id: #{item.id})"
      end
    end
  end

  def self.down
  end
end
