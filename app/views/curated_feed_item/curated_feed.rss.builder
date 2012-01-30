xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @curated_feed.title
    xml.description @curated_feed.description if @curated_feed.description

    for curated_feed_item in @curated_feed_items
      xml.item do
        xml.title curated_feed_item.title
        xml.description curated_feed_item.description
        xml.pubDate curated_feed_item.created_at.to_s(:rfc822)
        xml.link curated_feed_item.original_url
      end
    end
  end
end
