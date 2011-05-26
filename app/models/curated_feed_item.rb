class CuratedFeedItem < ActiveRecord::Base

  attr_protected :raw

  belongs_to :curated_feed

  alias_attribute :url, :original_url
  alias_attribute :feed, :curated_feed
  
  validates_presence_of :original_url
  validates_presence_of :curated_feed_id

  before_validation :set_pub_date
  before_save :update_embedly

  def update_embedly
    embedly = EmbedlyService.new
    embedly.fetch(self.original_url)
    if embedly.ok?
      self.raw = embedly.raw
      self.provider_url = embedly.properties[:provider_url]
      self.title = embedly.properties[:title]
      self.description = embedly.properties[:description]
    else
      errors.add(:objectify, embedly.error)
    end
    return embedly.ok?
  end

  def objectify
    @objectify ||= structify(self.raw)
    return @objectify
  end
    
  private

  def set_pub_date
    self.pub_date = DateTime.now if self.pub_date.blank?
    return true
  end

  def structify(item)
    item = ActiveSupport::JSON.decode(item) unless item.is_a? Hash
    struct = OpenStruct.new(item)
    item.each do |key, value|
      if value.is_a? Hash
        obj = structify(value)
        struct.send("#{key}=".to_sym, obj)
      elsif value.is_a? Array
        value = struct.send(key.to_sym)
        (0 .. value.size-1).each do |i|
          value[i] = structify(value[i]) if value[i].is_a? Hash
        end
      end
    end
    return struct
  end

end
