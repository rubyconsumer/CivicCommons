class CuratedFeed < ActiveRecord::Base
  extend FriendlyId

  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :curated_feed_items, :dependent => :destroy
  alias_attribute :items, :curated_feed_items

  friendly_id :title, :use => :slugged
  def should_generate_new_friendly_id?
    new_record? || slug.nil?
  end

end
