class CCML::Tag::CuratedFeedTag < CCML::Tag::TagPair

  # 'index' method with no opts grabs issue id from segment_1
  #
  # {ccml:curated_feed}
  # <h1>{title}</h1>
  # <ul>
  # <li>id: {id}</li>
  # <li>description: {description}</li>
  # </ul>
  # {/ccml:curated_feed}
  #
  # {ccml:curated_feed id='id or cached-slug or segment'}
  # {/ccml:curated_feed}
  def index
    @opts[:id] = @segments[1] unless @opts.has_key?(:id)
    feed = CuratedFeed.includes(:curated_feed_items).find(@opts[:id])
    return process_tag_body(feed)
  rescue ActiveRecord::RecordNotFound => e
    return nil
  end

  # Iterates through all curated feeds
  #
  # {ccml:curated_feed:all}
  # <h1>{title}</h1>
  # <ul>
  # <li>id: {id}</li>
  # <li>description: {description}</li>
  # </ul>
  # {/ccml:curated_feed:all}
  def all
    return process_tag_body(CuratedFeed.all)
  end

  # Iterates through all the items associated with a given feed
  #
  # {ccml:curated_feed:items id="really-cool-stuff"}
  # <h2>{title}</h2>
  # <ul>
  # <li>id: {id}</li>
  # <li>original_url: {original_url}</li>
  # <li>provider_url: {provider_url}</li>
  # <li>title: {title}</li>
  # <li>description: {description}</li>
  # <li>pub_date: {pub_date}</li>
  # <li>thumbnail_url: {objectify.oembed.thumbnail_url}</li>
  # <li>thumbnail_width: {objectify.oembed.thumbnail_width}</li>
  # <li>thumbnail_height: {objectify.oembed.thumbnail_height}</li>
  # </ul>
  # {/ccml:curated_feed:items}
  def items
    @opts[:id] = @segments[1] unless @opts.has_key?(:id)
    feed = CuratedFeed.includes(:curated_feed_items).find(@opts[:id])
    return process_tag_body(feed.items)
  rescue ActiveRecord::RecordNotFound => e
    return nil
  end

end
