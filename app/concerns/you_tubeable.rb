module YouTubeable

  def self.included(base)
    base.before_save :embed_youtube_video, :if => [:youtube_link?]
    base.validates :url, :you_tubeable => true
  end
  
  YOUTUBE_REGEX = /^http:\/\/www\.youtube\.com\/watch\?.*v=([-\d\w]+).*/

  def youtube_link?
    YOUTUBE_REGEX.match(self.url)
  end
  
  def embed_youtube_video
    video_id = self.url.gsub(YOUTUBE_REGEX, '\1')
    if self.respond_to?(:youtube_id)
      self.youtube_id = video_id
    end
    self.embed_target = embed_code_for_video(video_id)
  end

  def embed_code_for_video(video_id)
    "<object width='300' height='180'><param name='wmode' value='opaque'></param><param name='movie' value='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed wmode='opaque' src='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='300' height='180'></embed></object>"
  end
  
  def you_tubeable?
    true
  end
  
end
