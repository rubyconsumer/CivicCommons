module YouTubeable

  def self.included(base)
    base.before_save :embed_youtube_video, :if => :youtube_link? 
  end

  
  YOUTUBE_REGEX = /^http:\/\/www.youtube.com\/watch\?.*v=([\d\w]+)/

  def youtube_link?
    YOUTUBE_REGEX.match(self.url)
  end
  
  def embed_youtube_video
    video_id = self.url.gsub(YOUTUBE_REGEX, '\1')
    self.embed_target = "<object width='320' height='192'><param name='movie' value='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='320' height='192'></embed></object>"
  end
  
end
