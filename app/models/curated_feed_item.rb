class CuratedFeedItem < ActiveRecord::Base

  attr_protected :raw

  belongs_to :curated_feed

  alias_attribute :url, :original_url
  alias_attribute :feed, :curated_feed
  
  validates_presence_of :url

  def reset(url = nil)
    self.original_url = url unless url.nil?
    self.provider_url = nil
    self.title = nil
    self.description = nil
    self.raw = nil
    self.update_raw
  end

  def update_raw
    embedly = EmbedlyService.new
    embedly.fetch(self.original_url)
    if embedly.ok?
      self.raw = embedly.raw
      self.provider_url = embedly.properties[:provider_url] if self.provider_url.blank?
      self.title = embedly.properties[:title] if self.title.blank?
      self.description = embedly.properties[:description] if self.description.blank?
    end
  end

  def objectify
    @objectify ||= structify(self.raw)
    return @objectify
  end
    
  private

  def before_save
    self.pub_date = DateTime.now if self.pub_date.blank?
    self.update_raw if self.raw.blank?
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
