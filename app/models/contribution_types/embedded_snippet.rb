class EmbeddedSnippet < Contribution
  include EmbeddedLinkable
  include YouTubeable
  
  #only accepts YouTube videos for now
  validates :url, :format => YouTubeable::YOUTUBE_REGEX
  
end
