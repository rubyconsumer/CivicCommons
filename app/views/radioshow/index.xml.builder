xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => radioshow_index_url, :rel => "self", :type => "application/rss+xml")
    xml.title 'The Civic Commons Radio Show'
    xml.description 'The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action.'
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link radioshow_index_url
    xml.image do
      xml.url "#{root_url}images/cc_podcast.jpg"
      xml.title 'The Civic Commons Radio Show'
      xml.link radioshow_index_url
    end
    xml.language "en-us"
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822
    for show in @radioshows
      xml.item do
        xml.title show.title
        xml.link radioshow_url(show)
        xml.guid radioshow_url(show)
        xml.description show.summary
        xml.pubDate show.published.to_s(:rfc822)
      end
    end
  end
end
