class CuratedFeed < ActiveRecord::Base
  
  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :curated_feed_items, :dependent => :destroy
  alias_attribute :items, :curated_feed_items

  has_friendly_id :title, :use_slug => true, :strip_non_ascii => true

end
