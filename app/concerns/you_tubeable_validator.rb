class YouTubeableValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Link is not a valid YouTube URL" unless valid_youtube_url_format?(value)
  end
  
  def valid_youtube_url_format?(url)
    url =~ YouTubeable::YOUTUBE_REGEX || url.blank?
  end
  
end