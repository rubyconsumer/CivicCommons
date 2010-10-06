require 'open-uri'
require 'nokogiri'

module EmbeddedLinkable

  # override_target_doc used in specs so we don't need a network connection to get links when running specs
  attr_accessor :target_doc, :override_target_doc, :override_url_exists
  
  def self.included(base)
    base.before_create :get_link_information, :unless => :already_set_title_and_description?
    base.validates :url, :presence=>true, :embedded_link => true
  end
  
  def get_link_information
    self.target_doc = self.override_target_doc ? File.open(self.override_target_doc) : open(CGI::unescapeHTML(self.url))
    doc = Nokogiri::HTML(self.target_doc) do |config|
       config.noent.noblanks
    end
    title = doc.search("//title").first
    description = doc.search("//meta[@name='description']").first
    if description
      description = description.attributes['content']
    else
      description = doc.search("//p[1]").first
    end
    self.title = title.content.strip.gsub(/\s+/, ' ') if title && self.title.blank?
    self.description = description.content.strip if description && self.description.blank?
  end
  
  def already_set_title_and_description?
    self.title && self.description
  end
  
end
