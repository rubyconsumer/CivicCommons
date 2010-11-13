require 'open-uri'
require 'nokogiri'

module EmbeddedLinkable

  # override_target_doc used in specs so we don't need a network connection to get links when running specs
  attr_accessor :target_doc, :override_target_doc, :override_url_exists
  
  def self.included(base)
    base.before_save :get_link_information, :if => :new_record_or_url_changed?
    base.validates :url, :presence=>true, :embedded_link => true
  end
  
  def get_link_information
    EmbeddedLinkable.get_link_information(self)
  end

  def self.get_link_information(instance)
    instance.target_doc = instance.override_target_doc ? File.open(instance.override_target_doc) : open(CGI::unescapeHTML(instance.url))
    doc = Nokogiri::HTML(instance.target_doc) do |config|
       config.noent.noblanks
    end
    title = doc.search("//title").first
    description = doc.search("//meta[@name='description']").first
    if description
      description = description.attributes['content']
    #else
    #  description = doc.search("//p[1]").first
    end
    instance.title = title.content.strip.gsub(/\s+/, ' ') if title && instance.title.blank?
    instance.description = description.content.strip if description && instance.description.blank?
  end
  
  def new_record_or_url_changed?
    self.new_record? || self.url_changed?
  end
  
  def embedded_linkable?
    true
  end
  
end
