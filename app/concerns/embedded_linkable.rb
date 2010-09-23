require 'open-uri'
require 'nokogiri'

module EmbeddedLinkable
  YOUTUBE_REGEX = /^http:\/\/www.youtube.com\/watch\?.*v=([\d\w]+)/
  
  def self.included(base)
    base.before_create :get_link_information
    base.before_create :embed_youtube_video, :if => :youtube_link?
    
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
    self.title = title.content.strip if title
    self.description = description.content.strip if description
  end
  
  def youtube_link?
    YOUTUBE_REGEX.match(self.url)
  end
  
  def embed_youtube_video
    video_id = self.url.gsub(YOUTUBE_REGEX, '\1')
    self.content = "<object width='320' height='192'><param name='movie' value='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='320' height='192'></embed></object>"
  end
end