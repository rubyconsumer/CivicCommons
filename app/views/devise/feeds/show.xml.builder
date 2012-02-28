xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => feed_url(@feed, :format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title @feed.title
    xml.description @feed.description
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link feed_url(@feed, :format => :xml)
    xml.image do
      xml.url "#{root_url}images/cc_podcast.jpg"
      xml.title @feed.title
      xml.link feed_url(@feed, :format => :xml)
    end
    xml.language "en-us"
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822
    for item in @feed.items
      xml.item do
        xml.title item.title
        xml.link item.original_url
        xml.guid item.original_url
        xml.description item.description
        xml.pubDate item.pub_date.to_s(:rfc822)
      end
    end
  end
end
