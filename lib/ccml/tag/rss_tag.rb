require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class CCML::Tag::RssTag < CCML::Tag::TagPair

  CACHE_KEY = '__ccml_rss_tag_cached_data__'

  # Retrieve an RSS feed and process both the channel and item elements.
  # Channel elements will be available in every iteration but will not change.
  # Retrieved RSS data will be cached after every request using the Rails
  # ActiveSupport::Cache::FileStore mechanism.
  #
  # Tag Options:
  #   url: The url of the feed to be processed (required)
  #   limit: The maximum number of items to process (optional)
  #   refresh: The number of minutes to cache the data (optional)
  #
  # {ccml:rss url="<feed url>" limit="<max to display>" refresh="<cache time in minutes>"}
  #   RSS Version: {rss_version}<br />
  #   RSS Feed Version: {rss_feed_version}<br />
  #   RSS Feed Type: {rss_feed_type}<br />
  #   Channel Title: {channel_title}<br />
  #   Channel Description: {channel_description}<br />
  #   Channel Copyright: {channel_copyright}<br />
  #   Channel Link: {channel_link}<br />
  #   Channel Language: {channel_language}<br />
  #   Channel Publication Date: {channel_date format='%m-%d-%Y %I:%M %p'}<br />
  #   Channel Image Title: {channel_image_title}<br />
  #   Channel Image URL: {channel_image_url}<br />
  #   Channel Image Link: {channel_image_link}<br />
  #   Channel Image Description: {channel_image_description}<br />
  #   Channel Image Height: {channel_image_height}<br />
  #   Channel Image Width: {channel_item_width}<br />
  #   Channel Item Count: {channel_item_count}<br />
  #   Item Title: {item_title}<br />
  #   Item Link: {item_link}<br />
  #   Item Description: {item_description}<br />
  #   Item Publication Date: {item_date format='%m-%d-%Y %I:%M %p'}<br />
  # {/ccml:rss}
  def index
    rss = parse_rss
    return nil if rss.nil?

    items = []
    limit = [rss.items.size, @opts[:limit].to_i].min
    limit = rss.items.size if limit == 0

    channel = parse_channel(rss, 'channel_')

    (0..limit-1).each do |i|
      data = {}
      channel['channel_item_count'] = limit
      data.merge!(channel)
      data.merge!(parse_item(rss.items[i], 'item_'))
      items << data
    end

    return process_tag_body(items)
  end

  # Retrieve an RSS feed and process the item elements. Retrieved RSS data 
  # will be cached after every request using the Rails
  # ActiveSupport::Cache::FileStore mechanism.
  #
  # Tag Options:
  #   url: The url of the feed to be processed (required)
  #   limit: The maximum number of items to process (optional)
  #   refresh: The number of minutes to cache the data (optional)
  #
  # {ccml:rss:items url="<feed url>" limit="<max to display>" refresh="<cache time in minutes>"}
  #   Title: {title}<br />
  #   Link: {link}<br />
  #   Description: {description}<br />
  #   Publication Date: {date format='%m-%d-%Y %I:%M %p'}<br />
  # {/ccml:rss:items}
  def items
    rss = parse_rss
    
    if rss.nil?
      raise CCML::Error::ExternalSourceError, "RSS feed url: #{@opts[:url]} is not valid."
    end

    items = []
    limit = [rss.items.size, @opts[:limit].to_i].min
    limit = rss.items.size if limit == 0

    (0..limit-1).each do |i|
      items << (parse_item(rss.items[i]))
    end
    return process_tag_body(items)
  end

  # Retrieve an RSS feed and process the channel elements. This tag will
  # iterate only once no matter how many items have been retrieved.
  # Retrieved RSS data will be cached after every request using the Rails
  # ActiveSupport::Cache::FileStore mechanism.
  #
  # Tag Options:
  #   url: The url of the feed to be processed (required)
  #   refresh: The number of minutes to cache the data (optional)
  #
  # {ccml:rss:channel url="<feed url>" refresh="<cache time in minutes>"}
  #   RSS Version: {rss_version}<br />
  #   RSS Feed Version: {rss_feed_version}<br />
  #   RSS Feed Type: {rss_feed_type}<br />
  #   Title: {title}<br />
  #   Description: {description}<br />
  #   Copyright: {copyright}<br />
  #   Link: {link}<br />
  #   Language: {language}<br />
  #   Publication Date: {date format='%m-%d-%Y %I:%M %p'}<br />
  #   Image Title: {image_title}<br />
  #   Image URL: {image_url}<br />
  #   Image Link: {image_link}<br />
  #   Image Description: {image_description}<br />
  #   Image Height: {image_height}<br />
  #   Image Width: {item_width}<br />
  #   Item Count: {item_count}<br />
  # {/ccml:rss:channel}
  def channel
    rss = parse_rss
    if rss.nil?
      return nil
    else
      return process_tag_body(parse_channel(rss))
    end
  end

  private

  def parse_item(rss, prefix = '')
    item = {
      "#{prefix}title" => rss.title,
      "#{prefix}link" => rss.link,
      "#{prefix}description" => rss.description,
      "#{prefix}date" => rss.date,
    }
    return item
  end

  def parse_channel(rss, prefix = '')
    channel = { }
    channel["rss_version"] = rss.version
    channel["rss_feed_version"] = rss.feed_version
    channel["rss_feed_type"] = rss.feed_type
    channel["#{prefix}title"] = rss.channel.title
    channel["#{prefix}description"] = rss.channel.description
    channel["#{prefix}copyright"] = rss.channel.copyright
    channel["#{prefix}link"] = rss.channel.link
    channel["#{prefix}language"] = rss.channel.language
    channel["#{prefix}date"] = rss.channel.date
    if rss.channel.image
      channel["#{prefix}image_title"] = rss.channel.image.title
      channel["#{prefix}image_url"] = rss.channel.image.url
      channel["#{prefix}image_link"] = rss.channel.image.link
      channel["#{prefix}image_description"] = rss.channel.image.description
      channel["#{prefix}image_height"] = rss.channel.image.width
      channel["#{prefix}image_width"] = rss.channel.image.height
    end
    channel["#{prefix}item_count"] = rss.channel.items.size
    return channel
  end

  def parse_rss

    # get the cache and refresh data
    cache_key = "#{CACHE_KEY}#{@opts[:url]}"
    cache = Rails.cache.fetch(cache_key)
    refresh = @opts[:refresh].to_i

    # check for existing and non-stale data for this url
    if cache.nil? or cache[:time] < refresh.minutes.ago
      # get new data
      content = ''
      open(@opts[:url]) do |s| content = s.read end
      rss = RSS::Parser.parse(content, false)
    else
      # use the cached data
      rss = cache[:rss]
    end

    # save the data back to the cache
    cache = {
      :time => Time.now,
      :rss => rss
    }
    Rails.cache.write(cache_key, cache)

  rescue TypeError, Errno::ENOENT => e
    rss = nil
  ensure
    return rss
  end

end
