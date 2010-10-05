require 'open-uri'
require 'nokogiri'

module EmbeddedLinkable

  def self.included(base)
    base.before_create :get_link_information
    base.validates :url, :presence=>true, :embedded_link => true
  end
  
  def get_link_information
    doc = Nokogiri::HTML(open(CGI::unescapeHTML(self.url))) do |config|
       config.noent.noblanks
    end
    title = doc.search("//title").first
    description = doc.search("//meta[@name='description']").first
    if description
      description = description.attributes['content']
    else
      description = doc.search("//p[1]").first
    end
    self.title = title.content.strip.gsub(/\s+/, ' ') if title
    self.description = description.content.strip if description
  end
  
end
