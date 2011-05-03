xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => news_index_url(:format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title "The Civic Commons In The News"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link news_index_url(:format => :xml)
    xml.language "en-us"
    for news in @news_items
      xml.item do
        xml.title news.title
        xml.link news_url(news)
        xml.guid news_url(news)
        xml.description news.summary
        xml.pubDate news.published.to_s(:rfc822)
      end
    end
  end
end
