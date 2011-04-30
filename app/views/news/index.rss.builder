xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Civic Commons: News"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright (current year) The Civic Commons"
    xml.link news_index_url
    xml.language "en-us"

    for item in @news_items
      xml.item do
        xml.title item.title
        xml.link news_url(item)
        xml.guid news_url(item)
        xml.description item.summary
        xml.pubDate item.published.to_s(:rfc822)
      end
    end
  end
end
