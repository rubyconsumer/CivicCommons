xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => news_index_url(:format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title "The Civic Commons In The News"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link news_index_url
    xml.image do
      xml.url "#{root_url}images/cc_podcast.jpg"
      xml.title 'The Civic Commons In The News'
      xml.link news_index_url
    end
    xml.language "en-us"
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822
    for item in @news_items
      xml.item do
        xml.title item.title
        xml.link news_index_url
        xml.guid "#{news_index_url}?#{item.slug}"
        xml.description item.summary
        xml.pubDate item.published.to_s(:rfc822)
      end
    end
  end
end
