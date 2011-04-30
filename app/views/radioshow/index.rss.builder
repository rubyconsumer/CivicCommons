xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Civic Commons: Radio Show"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright (current year) The Civic Commons"
    xml.link radioshow_index_url
    xml.language "en-us"

    for show in @radio_shows
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
