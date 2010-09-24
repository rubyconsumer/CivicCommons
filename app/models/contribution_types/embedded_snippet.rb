class EmbeddedSnippet < Contribution
  include EmbeddedLinkable
  
  #only accepts YouTube videos for now
  validates :url, :format => EmbeddedLinkable::YOUTUBE_REGEX
  
end